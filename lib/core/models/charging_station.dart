class ChargingStation {
  final String id;
  final String name;
  final String operator;
  final String address;
  final double lat;
  final double lon;
  final String openingHours;
  final String phone;
  final List<String> connectors;
  final int? capacity;
  double? distanceKm;

  ChargingStation({
    required this.id,
    required this.name,
    required this.operator,
    required this.address,
    required this.lat,
    required this.lon,
    this.openingHours = '',
    this.phone = '',
    this.connectors = const [],
    this.capacity,
    this.distanceKm,
  });
}
