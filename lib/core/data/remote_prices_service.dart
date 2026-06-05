import 'package:dio/dio.dart';
import 'nomos_prices.dart';

class RemotePricesService {
  static const String _url =
      'https://kokkinopoulos-eng.github.io/fuelspot-legal/prices.json';

  static List<NomosData>? _cached;
  static String? _cachedDate;

  static List<NomosData> get current => _cached ?? NomosRepository.all;
  static String get date => _cachedDate ?? NomosRepository.dataDate;

  static Future<void> fetchAndUpdate() async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));
      final response = await dio.get(_url);
      final data = response.data as Map<String, dynamic>;
      final date = data['date'] as String? ?? '';
      final nomoi = (data['nomoi'] as List).map((n) => NomosData(
        name: n['name'] as String,
        unleaded95: (n['unleaded95'] as num?)?.toDouble(),
        unleaded98: (n['unleaded98'] as num?)?.toDouble(),
        diesel: (n['diesel'] as num?)?.toDouble(),
        lpg: (n['lpg'] as num?)?.toDouble(),
      )).toList();
      _cached = nomoi;
      _cachedDate = date;
      print('Remote prices loaded: $date (${nomoi.length} nomoi)');
    } catch (e) {
      print('Remote prices failed, using hardcoded: $e');
    }
  }
}
