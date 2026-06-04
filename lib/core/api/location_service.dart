import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationResult {
  final double lat;
  final double lon;
  final double accuracy;
  final LocationSource source;
  const LocationResult({required this.lat, required this.lon, required this.accuracy, required this.source});
}

enum LocationSource { gps, cached, manual }
enum LocationStatus { idle, requesting, acquiring, ready, error, denied }

class LocationService extends ChangeNotifier {
  LocationStatus _status = LocationStatus.idle;
  LocationResult? _current;
  String? _errorMessage;
  double _currentAccuracy = 9999;
  StreamSubscription<Position>? _positionSub;

  LocationStatus get status => _status;
  LocationResult? get current => _current;
  String? get errorMessage => _errorMessage;
  double get currentAccuracy => _currentAccuracy;

  Future<LocationResult?> getAccuratePosition({double targetAccuracyMeters = 100.0, Duration timeout = const Duration(seconds: 15)}) async {
    _status = LocationStatus.requesting; _errorMessage = null; notifyListeners();
    if (!await Geolocator.isLocationServiceEnabled()) { _setError('Το GPS είναι απενεργοποιημένο.'); return null; }
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
      _status = LocationStatus.denied;
      _errorMessage = perm == LocationPermission.deniedForever ? 'Η άδεια αρνήθηκε μόνιμα.' : 'Απαιτείται άδεια.';
      notifyListeners(); return null;
    }
    _status = LocationStatus.acquiring; notifyListeners();
    try {
      final last = await Geolocator.getLastKnownPosition();
      if (last != null) {
        _current = LocationResult(lat: last.latitude, lon: last.longitude, accuracy: last.accuracy, source: LocationSource.cached);
        _currentAccuracy = last.accuracy; notifyListeners();
      }
    } catch (_) {}
    final completer = Completer<LocationResult?>();
    final settings = AndroidSettings(accuracy: LocationAccuracy.high, distanceFilter: 0);
    _positionSub?.cancel();
    _positionSub = Geolocator.getPositionStream(locationSettings: settings).listen(
      (pos) {
        _currentAccuracy = pos.accuracy;
        final result = LocationResult(lat: pos.latitude, lon: pos.longitude, accuracy: pos.accuracy, source: LocationSource.gps);
        _current = result; notifyListeners();
        if (pos.accuracy <= targetAccuracyMeters && !completer.isCompleted) completer.complete(result);
      },
      onError: (e) { if (!completer.isCompleted) completer.completeError(e); },
    );
    Timer(timeout, () {
      if (!completer.isCompleted) {
        if (_current != null) completer.complete(_current); else completer.completeError('Timeout');
      }
    });
    try {
      final result = await completer.future;
      _positionSub?.cancel(); _status = LocationStatus.ready; _current = result; notifyListeners(); return result;
    } catch (e) { _setError('Αδυναμία εντοπισμού θέσης.'); return _current; }
  }

  void setManual(double lat, double lon) {
    _current = LocationResult(lat: lat, lon: lon, accuracy: 0, source: LocationSource.manual);
    _status = LocationStatus.ready; _errorMessage = null; notifyListeners();
  }

  Future<void> openSettings() => Geolocator.openLocationSettings();
  void _setError(String msg) { _status = LocationStatus.error; _errorMessage = msg; notifyListeners(); }
  @override
  void dispose() { _positionSub?.cancel(); super.dispose(); }
}
