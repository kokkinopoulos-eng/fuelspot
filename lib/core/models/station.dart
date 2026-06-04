enum StationDataSource { osm, real, mock }

class Station {
  final String id;
  final String name;
  final String brand;
  final String address;
  final double lat;
  final double lon;
  final Map<String, double> prices;
  final DateTime updatedAt;
  final StationDataSource dataSource;
  double? distanceKm;

  Station({
    required this.id, required this.name, required this.brand,
    required this.address, required this.lat, required this.lon,
    required this.prices, required this.updatedAt,
    this.dataSource = StationDataSource.mock, this.distanceKm,
  });

  factory Station.fromJson(Map<String, dynamic> json) => Station(
    id: json['id'].toString(), name: json['name'] as String,
    brand: json['brand'] as String? ?? '', address: json['address'] as String? ?? '',
    lat: (json['lat'] as num).toDouble(), lon: (json['lon'] as num).toDouble(),
    prices: Map<String, double>.from((json['prices'] as Map<String, dynamic>)
        .map((k, v) => MapEntry(k, (v as num).toDouble()))),
    updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
    dataSource: StationDataSource.real,
  );

  double? priceFor(String fuelType) => prices[fuelType];

  bool get hasPrices => prices.isNotEmpty;
  bool get isOsmOnly => dataSource == StationDataSource.osm;

  Station copyWith({double? distanceKm, Map<String, double>? prices}) => Station(
    id: id, name: name, brand: brand, address: address,
    lat: lat, lon: lon, updatedAt: updatedAt, dataSource: dataSource,
    prices: prices ?? this.prices,
    distanceKm: distanceKm ?? this.distanceKm,
  );
}

class FuelType {
  static const String unleaded95 = 'unleaded_95';
  static const String unleaded98 = 'unleaded_98';
  static const String diesel = 'diesel';
  static const String lpg = 'lpg';
  static const List<String> all = [unleaded95, unleaded98, diesel, lpg];

  static String label(String type) {
    switch (type) {
      case unleaded95: return 'Αμόλυβδη 95';
      case unleaded98: return 'Αμόλυβδη 98';
      case diesel: return 'Diesel';
      case lpg: return 'LPG';
      default: return type;
    }
  }

  static String shortLabel(String type) {
    switch (type) {
      case unleaded95: return '95';
      case unleaded98: return '98';
      case diesel: return 'DSL';
      case lpg: return 'LPG';
      default: return type;
    }
  }
}
