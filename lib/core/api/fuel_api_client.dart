import 'package:dio/dio.dart';
import '../models/station.dart';

class FuelApiClient {
  static const bool _realApiEnabled = false;
  static const String _realApiUrl = 'https://YOUR_BACKEND_URL/api';

  static const List<String> _osmServers = [
    'https://overpass-api.de/api',
    'https://lz4.overpass-api.de/api',
    'https://z.overpass-api.de/api',
    'https://overpass.kumi.systems/api',
  ];

  Future<List<Station>> getNearbyStations({
    required double lat,
    required double lon,
    double radiusKm = 5.0,
    String? fuelType,
    int limit = 100,
  }) async {
    if (_realApiEnabled) {
      return _getRealStations(lat: lat, lon: lon, radiusKm: radiusKm, fuelType: fuelType);
    }
    try {
      final stations = await _getOsmStations(lat: lat, lon: lon, radiusKm: radiusKm, limit: limit);
      return stations;
    } catch (e) {
      print('OSM FAILED: $e');
      return _mockStations(lat, lon);
    }
  }

  Future<List<Station>> _getOsmStations({
    required double lat,
    required double lon,
    required double radiusKm,
    required int limit,
  }) async {
    final r = (radiusKm * 1000).round();
    final query = '[out:json];(node[amenity=fuel](around:$r,$lat,$lon);way[amenity=fuel](around:$r,$lat,$lon););out center $limit;';

    Response? response;
    Exception? lastError;

    for (final server in _osmServers) {
      try {
        final dio = Dio(BaseOptions(
          baseUrl: server,
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'User-Agent': 'FuelSpot/1.0 (gr.webdevelopment.fuelspot)',
            'Accept': '*/*',
          },
        ));
        response = await dio.post(
          '/interpreter',
          data: query,
          options: Options(contentType: 'text/plain'),
        );
        break;
      } catch (e) {
        print('Server $server failed: $e');
        lastError = Exception(e.toString());
        continue;
      }
    }

    if (response == null) throw lastError ?? Exception('All OSM servers failed');

    final elements = (response.data['elements'] as List? ?? []);
    final stations = <Station>[];

    for (final el in elements) {
      final tags = el['tags'] as Map<String, dynamic>? ?? {};
      double? elLat, elLon;
      if (el['type'] == 'node') {
        elLat = (el['lat'] as num?)?.toDouble();
        elLon = (el['lon'] as num?)?.toDouble();
      } else if (el['center'] != null) {
        elLat = (el['center']['lat'] as num?)?.toDouble();
        elLon = (el['center']['lon'] as num?)?.toDouble();
      }
      if (elLat == null || elLon == null) continue;

      final name = (tags['name'] ?? tags['brand'] ?? tags['operator'] ?? 'Pratirion') as String;
      final brand = (tags['brand'] ?? tags['name'] ?? '') as String;

      stations.add(Station(
        id: '${el["type"]}_${el["id"]}',
        name: name,
        brand: _normalizeBrand(brand),
        address: _buildAddress(tags),
        lat: elLat,
        lon: elLon,
        prices: const {},
        updatedAt: DateTime.now(),
        dataSource: StationDataSource.osm,
        operator: (tags['operator'] ?? '') as String,
        phone: (tags['phone'] ?? tags['contact:phone'] ?? '') as String,
        openingHours: (tags['opening_hours'] ?? '') as String,
      ));
    }
    return stations;
  }

  String _normalizeBrand(String brand) {
    final b = brand.toUpperCase().trim();
    const map = {
      'BP': 'BP', 'SHELL': 'Shell', 'EKO': 'EKO',
      'ELINOIL': 'ELINOIL', 'REVOIL': 'Revoil',
      'AEGEAN': 'Aegean', 'AVIN': 'AVIN', 'CYCLON': 'Cyclon',
      'MAMIDOIL': 'Mamidoil', 'JETOIL': 'JetOil',
      'SILKOIL': 'SILKOIL', 'ARGO': 'ARGO',
    };
    return map[b] ?? brand;
  }

  String _buildAddress(Map<String, dynamic> tags) {
    final parts = <String>[];
    if (tags['addr:street'] != null) parts.add(tags['addr:street'] as String);
    if (tags['addr:housenumber'] != null) parts.add(tags['addr:housenumber'] as String);
    if (tags['addr:city'] != null) parts.add(tags['addr:city'] as String);
    if (parts.isEmpty && tags['operator'] != null) return tags['operator'] as String;
    return parts.isNotEmpty ? parts.join(', ') : '';
  }

  Future<List<Station>> _getRealStations({
    required double lat,
    required double lon,
    double radiusKm = 5.0,
    String? fuelType,
  }) async {
    final dio = Dio(BaseOptions(baseUrl: _realApiUrl));
    final response = await dio.get('/stations/nearby', queryParameters: {
      'lat': lat, 'lon': lon, 'radius_km': radiusKm,
      if (fuelType != null) 'fuel_type': fuelType,
    });
    final List data = response.data['stations'] as List;
    return data.map((j) => Station.fromJson(j as Map<String, dynamic>)).toList();
  }

  List<Station> _mockStations(double lat, double lon) => [
    Station(id: '1', name: 'EKO', brand: 'EKO', address: 'Kontino pratirio',
        lat: lat + 0.003, lon: lon + 0.002,
        prices: const {}, updatedAt: DateTime.now()),
    Station(id: '2', name: 'BP', brand: 'BP', address: 'Kontino pratirio',
        lat: lat - 0.005, lon: lon + 0.004,
        prices: const {}, updatedAt: DateTime.now()),
    Station(id: '3', name: 'Shell', brand: 'Shell', address: 'Kontino pratirio',
        lat: lat + 0.007, lon: lon - 0.003,
        prices: const {}, updatedAt: DateTime.now()),
  ];
}
