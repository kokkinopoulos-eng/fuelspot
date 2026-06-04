import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../api/fuel_api_client.dart';
import '../api/location_service.dart';
import '../models/station.dart';

class FuelRepository extends ChangeNotifier {
  final FuelApiClient _api;
  List<Station> _stations = [];
  bool _loading = false;
  String? _error;
  String _selectedFuelType = FuelType.unleaded95;
  double _radiusKm = 5.0;
  Set<String> _favoriteIds = {};

  List<Station> get stations => _stations;
  bool get loading => _loading;
  String? get error => _error;
  String get selectedFuelType => _selectedFuelType;
  double get radiusKm => _radiusKm;
  Set<String> get favoriteIds => _favoriteIds;

  FuelRepository(this._api) { _loadFavorites(); }

  void setFuelType(String type) { _selectedFuelType = type; _sortStations(); notifyListeners(); }
  void setRadius(double km) { _radiusKm = km; notifyListeners(); }

  Future<void> loadNearby(LocationResult location) async {
    _loading = true; _error = null; notifyListeners();
    try {
      final raw = await _api.getNearbyStations(lat: location.lat, lon: location.lon, radiusKm: _radiusKm, fuelType: _selectedFuelType);
      _stations = raw.map((s) => s.copyWith(distanceKm: _haversineKm(location.lat, location.lon, s.lat, s.lon))).toList();
      _sortStations();
    } catch (e) {
      _error = 'Σφάλμα φόρτωσης δεδομένων.';
      debugPrint('FuelRepository error: $e');
    } finally {
      _loading = false; notifyListeners();
    }
  }

  void _sortStations() {
    _stations.sort((a, b) {
      final pa = a.priceFor(_selectedFuelType), pb = b.priceFor(_selectedFuelType);
      if (pa == null && pb == null) {
        // Αν δεν έχουν τιμές, ταξινόμηση by απόσταση
        final da = a.distanceKm ?? 999;
        final db = b.distanceKm ?? 999;
        return da.compareTo(db);
      }
      if (pa == null) return 1;
      if (pb == null) return -1;
      // Αν έχουν ίδια τιμή, ταξινόμηση by απόσταση
      if (pa == pb) {
        final da = a.distanceKm ?? 999;
        final db = b.distanceKm ?? 999;
        return da.compareTo(db);
      }
      return pa.compareTo(pb);
    });
  }

  bool isFavorite(String id) => _favoriteIds.contains(id);

  Future<void> toggleFavorite(String id) async {
    if (_favoriteIds.contains(id)) _favoriteIds.remove(id); else _favoriteIds.add(id);
    await _saveFavorites(); notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final box = await Hive.openBox<String>('favorites');
    _favoriteIds = box.values.toSet(); notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final box = await Hive.openBox<String>('favorites');
    await box.clear(); await box.addAll(_favoriteIds);
  }

  static double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0;
    final dLat = _toRad(lat2 - lat1), dLon = _toRad(lon2 - lon1);
    final a = sin(dLat/2)*sin(dLat/2) + cos(_toRad(lat1))*cos(_toRad(lat2))*sin(dLon/2)*sin(dLon/2);
    return R * 2 * atan2(sqrt(a), sqrt(1-a));
  }
  static double _toRad(double deg) => deg * pi / 180;
}
