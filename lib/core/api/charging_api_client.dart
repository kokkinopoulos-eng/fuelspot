import 'package:dio/dio.dart';
import '../models/charging_station.dart';

class ChargingApiClient {
  static const List<String> _osmServers = [
    'https://overpass-api.de/api',
    'https://lz4.overpass-api.de/api',
    'https://z.overpass-api.de/api',
    'https://overpass.kumi.systems/api',
  ];

  Future<List<ChargingStation>> getNearbyStations({
    required double lat,
    required double lon,
    double radiusKm = 5.0,
    int limit = 100,
  }) async {
    try {
      return await _getOsmStations(lat: lat, lon: lon, radiusKm: radiusKm, limit: limit);
    } catch (e) {
      print('Charging OSM FAILED: $e');
      return [];
    }
  }

  Future<List<ChargingStation>> _getOsmStations({
    required double lat,
    required double lon,
    required double radiusKm,
    required int limit,
  }) async {
    final r = (radiusKm * 1000).round();
    final query =
        '[out:json];(node[amenity=charging_station](around:$r,$lat,$lon);way[amenity=charging_station](around:$r,$lat,$lon););out center $limit;';

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
        print('Charging server $server failed: $e');
        lastError = Exception(e.toString());
      }
    }

    if (response == null) throw lastError ?? Exception('All OSM servers failed');

    final elements = (response.data['elements'] as List? ?? []);
    final stations = <ChargingStation>[];

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

      final name = (tags['name'] ?? tags['operator'] ?? 'Σταθμός Φόρτισης') as String;
      final connectors = _parseConnectors(tags);
      final capacityStr = tags['capacity'] as String?;
      final capacity = capacityStr != null ? int.tryParse(capacityStr) : null;

      stations.add(ChargingStation(
        id: '${el["type"]}_${el["id"]}',
        name: name,
        operator: (tags['operator'] ?? tags['brand'] ?? '') as String,
        address: _buildAddress(tags),
        lat: elLat,
        lon: elLon,
        openingHours: (tags['opening_hours'] ?? '') as String,
        phone: (tags['phone'] ?? tags['contact:phone'] ?? '') as String,
        connectors: connectors,
        capacity: capacity,
      ));
    }
    return stations;
  }

  List<String> _parseConnectors(Map<String, dynamic> tags) {
    final result = <String>[];
    if (tags['socket:type2'] != null) result.add('Type 2');
    if (tags['socket:ccs'] != null) result.add('CCS');
    if (tags['socket:chademo'] != null) result.add('CHAdeMO');
    if (tags['socket:type2_combo'] != null && !result.contains('CCS')) result.add('CCS');
    if (tags['socket:schuko'] != null) result.add('Schuko');
    if (tags['socket:type1'] != null) result.add('Type 1');
    if (result.isEmpty && tags['socket:type'] != null) result.add(tags['socket:type'] as String);
    return result;
  }

  String _buildAddress(Map<String, dynamic> tags) {
    final parts = <String>[];
    if (tags['addr:street'] != null) parts.add(tags['addr:street'] as String);
    if (tags['addr:housenumber'] != null) parts.add(tags['addr:housenumber'] as String);
    if (tags['addr:city'] != null) parts.add(tags['addr:city'] as String);
    return parts.isNotEmpty ? parts.join(', ') : '';
  }
}
