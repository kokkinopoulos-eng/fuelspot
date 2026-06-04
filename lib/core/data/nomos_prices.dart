// Δεδομένα από Παρατηρητήριο ΥΠΑΝ - 02/06/2026
class NomosData {
  final String name;
  final double? unleaded95;
  final double? unleaded98;
  final double? diesel;
  final double? lpg;
  const NomosData({required this.name, this.unleaded95, this.unleaded98, this.diesel, this.lpg});
}

class NomosRepository {
  static const String dataDate = '02/06/2026';

  static const List<NomosData> all = [
    NomosData(name: 'Αττικής', unleaded95: 2.010, unleaded98: 2.257, diesel: 1.698, lpg: 1.065),
    NomosData(name: 'Αιτωλίας και Ακαρνανίας', unleaded95: 2.073, unleaded98: 2.294, diesel: 1.751, lpg: 1.154),
    NomosData(name: 'Αργολίδος', unleaded95: 2.070, unleaded98: 2.295, diesel: 1.730, lpg: 1.037),
    NomosData(name: 'Αρκαδίας', unleaded95: 2.074, unleaded98: 2.307, diesel: 1.755, lpg: 1.174),
    NomosData(name: 'Άρτης', unleaded95: 2.041, unleaded98: 2.279, diesel: 1.709, lpg: 1.049),
    NomosData(name: 'Αχαΐας', unleaded95: 2.033, unleaded98: 2.280, diesel: 1.734, lpg: 1.204),
    NomosData(name: 'Βοιωτίας', unleaded95: 2.064, unleaded98: 2.291, diesel: 1.748, lpg: 1.155),
    NomosData(name: 'Γρεβενών', unleaded95: 2.077, unleaded98: 2.313, diesel: 1.766, lpg: 1.182),
    NomosData(name: 'Δράμας', unleaded95: 2.068, unleaded98: 2.253, diesel: 1.706, lpg: 1.091),
    NomosData(name: 'Δωδεκανήσου', unleaded95: 2.157, unleaded98: 2.383, diesel: 1.844, lpg: 1.417),
    NomosData(name: 'Έβρου', unleaded95: 2.074, unleaded98: 2.285, diesel: 1.749, lpg: 1.260),
    NomosData(name: 'Εύβοιας', unleaded95: 2.053, unleaded98: 2.278, diesel: 1.729, lpg: 1.157),
    NomosData(name: 'Ευρυτανίας', unleaded95: 2.090, unleaded98: 2.376, diesel: 1.800, lpg: 1.281),
    NomosData(name: 'Ζακύνθου', unleaded95: 2.118, unleaded98: 2.301, diesel: 1.768, lpg: 1.283),
    NomosData(name: 'Ηλείας', unleaded95: 2.060, unleaded98: 2.262, diesel: 1.722, lpg: 1.066),
    NomosData(name: 'Ημαθίας', unleaded95: 2.032, unleaded98: 2.265, diesel: 1.704, lpg: 0.995),
    NomosData(name: 'Ηρακλείου', unleaded95: 2.119, unleaded98: 2.282, diesel: 1.789, lpg: 1.326),
    NomosData(name: 'Θεσπρωτίας', unleaded95: 2.066, unleaded98: 2.269, diesel: 1.756, lpg: 1.139),
    NomosData(name: 'Θεσσαλονίκης', unleaded95: 2.030, unleaded98: 2.263, diesel: 1.710, lpg: 1.026),
    NomosData(name: 'Ιωαννίνων', unleaded95: 2.046, unleaded98: 2.310, diesel: 1.734, lpg: 1.005),
    NomosData(name: 'Καβάλας', unleaded95: 2.057, unleaded98: 2.267, diesel: 1.713, lpg: 1.040),
    NomosData(name: 'Καρδίτσης', unleaded95: 2.061, unleaded98: 2.281, diesel: 1.748, lpg: 1.108),
    NomosData(name: 'Καστοριάς', unleaded95: 2.064, unleaded98: 2.267, diesel: 1.738, lpg: 1.102),
    NomosData(name: 'Κέρκυρας', unleaded95: 2.107, unleaded98: 2.304, diesel: 1.789, lpg: 1.432),
    NomosData(name: 'Κεφαλληνίας', unleaded95: 2.169, unleaded98: 2.352, diesel: 1.834, lpg: 1.231),
    NomosData(name: 'Κιλκίς', unleaded95: 2.052, unleaded98: 2.286, diesel: 1.725, lpg: 1.121),
    NomosData(name: 'Κοζάνης', unleaded95: 2.043, unleaded98: 2.236, diesel: 1.737, lpg: 1.013),
    NomosData(name: 'Κορινθίας', unleaded95: 2.019, unleaded98: 2.261, diesel: 1.719, lpg: 1.097),
    NomosData(name: 'Κυκλάδων', unleaded95: 2.270, unleaded98: 2.471, diesel: 1.953, lpg: 1.408),
    NomosData(name: 'Λακωνίας', unleaded95: 2.070, unleaded98: 2.316, diesel: 1.766, lpg: 1.091),
    NomosData(name: 'Λαρίσης', unleaded95: 2.058, unleaded98: 2.273, diesel: 1.730, lpg: 1.065),
    NomosData(name: 'Λασιθίου', unleaded95: 2.114, unleaded98: 2.281, diesel: 1.779, lpg: 1.281),
    NomosData(name: 'Λέσβου', unleaded95: 2.104, unleaded98: 2.283, diesel: 1.779, lpg: 1.220),
    NomosData(name: 'Λευκάδος', unleaded95: 2.096, unleaded98: 2.303, diesel: 1.766, lpg: 1.215),
    NomosData(name: 'Μαγνησίας', unleaded95: 2.055, unleaded98: 2.275, diesel: 1.733, lpg: 1.107),
    NomosData(name: 'Μεσσηνίας', unleaded95: 2.065, unleaded98: 2.289, diesel: 1.745, lpg: 1.084),
    NomosData(name: 'Ξάνθης', unleaded95: 2.063, unleaded98: 2.266, diesel: 1.724, lpg: 1.116),
    NomosData(name: 'Πέλλης', unleaded95: 2.040, unleaded98: 2.268, diesel: 1.714, lpg: 1.034),
    NomosData(name: 'Πιερίας', unleaded95: 2.044, unleaded98: 2.270, diesel: 1.718, lpg: 1.049),
    NomosData(name: 'Πρέβεζας', unleaded95: 2.053, unleaded98: 2.285, diesel: 1.730, lpg: 1.076),
    NomosData(name: 'Ρεθύμνης', unleaded95: 2.117, unleaded98: 2.285, diesel: 1.784, lpg: 1.296),
    NomosData(name: 'Ροδόπης', unleaded95: 2.063, unleaded98: 2.262, diesel: 1.720, lpg: 1.105),
    NomosData(name: 'Σάμου', unleaded95: 2.157, unleaded98: 2.336, diesel: 1.838, lpg: 1.307),
    NomosData(name: 'Σερρών', unleaded95: 2.049, unleaded98: 2.267, diesel: 1.712, lpg: 1.044),
    NomosData(name: 'Τρικάλων', unleaded95: 2.058, unleaded98: 2.281, diesel: 1.742, lpg: 1.092),
    NomosData(name: 'Φθιώτιδος', unleaded95: 2.062, unleaded98: 2.284, diesel: 1.745, lpg: 1.127),
    NomosData(name: 'Φλωρίνης', unleaded95: 2.058, unleaded98: 2.271, diesel: 1.742, lpg: 1.058),
    NomosData(name: 'Φωκίδος', unleaded95: 2.071, unleaded98: 2.299, diesel: 1.754, lpg: 1.152),
    NomosData(name: 'Χαλκιδικής', unleaded95: 2.059, unleaded98: 2.281, diesel: 1.730, lpg: 1.083),
    NomosData(name: 'Χανίων', unleaded95: 2.112, unleaded98: 2.282, diesel: 1.782, lpg: 1.289),
    NomosData(name: 'Χίου', unleaded95: 2.118, unleaded98: 2.295, diesel: 1.799, lpg: 1.278),
  ];

  static NomosData detectNomos(double lat, double lon) {
    // Βάσει γεωγραφικών ορίων κάθε νομού
    if (lat >= 37.8 && lat <= 38.3 && lon >= 23.4 && lon <= 24.2) return _find("Αττικής");
    if (lat >= 40.4 && lat <= 40.9 && lon >= 22.6 && lon <= 23.3) return _find("Θεσσαλονίκης");
    if (lat >= 35.0 && lat <= 35.5 && lon >= 24.8 && lon <= 25.5) return _find("Ηρακλείου");
    if (lat >= 38.3 && lat <= 38.8 && lon >= 21.3 && lon <= 22.2) return _find("Αιτωλίας και Ακαρνανίας");
    if (lat >= 37.4 && lat <= 37.8 && lon >= 22.5 && lon <= 23.2) return _find("Αργολίδος");
    if (lat >= 37.3 && lat <= 37.8 && lon >= 21.8 && lon <= 22.6) return _find("Αρκαδίας");
    if (lat >= 39.0 && lat <= 39.5 && lon >= 20.8 && lon <= 21.5) return _find("Άρτης");
    if (lat >= 37.9 && lat <= 38.4 && lon >= 21.5 && lon <= 22.3) return _find("Αχαΐας");
    if (lat >= 38.2 && lat <= 38.6 && lon >= 22.8 && lon <= 23.4) return _find("Βοιωτίας");
    if (lat >= 40.0 && lat <= 40.4 && lon >= 21.3 && lon <= 22.0) return _find("Γρεβενών");
    if (lat >= 41.0 && lat <= 41.5 && lon >= 23.8 && lon <= 24.5) return _find("Δράμας");
    if (lat >= 36.0 && lat <= 36.5 && lon >= 27.0 && lon <= 28.5) return _find("Δωδεκανήσου");
    if (lat >= 41.3 && lat <= 41.8 && lon >= 26.0 && lon <= 26.8) return _find("Έβρου");
    if (lat >= 38.3 && lat <= 38.9 && lon >= 23.0 && lon <= 24.0) return _find("Εύβοιας");
    if (lat >= 38.8 && lat <= 39.3 && lon >= 21.6 && lon <= 22.2) return _find("Ευρυτανίας");
    if (lat >= 37.6 && lat <= 38.0 && lon >= 20.7 && lon <= 21.1) return _find("Ζακύνθου");
    if (lat >= 37.5 && lat <= 38.0 && lon >= 21.0 && lon <= 21.8) return _find("Ηλείας");
    if (lat >= 40.4 && lat <= 40.8 && lon >= 21.9 && lon <= 22.6) return _find("Ημαθίας");
    if (lat >= 39.5 && lat <= 40.0 && lon >= 20.5 && lon <= 21.2) return _find("Θεσπρωτίας");
    if (lat >= 39.5 && lat <= 40.0 && lon >= 20.8 && lon <= 21.5) return _find("Ιωαννίνων");
    if (lat >= 40.8 && lat <= 41.3 && lon >= 24.0 && lon <= 24.8) return _find("Καβάλας");
    if (lat >= 39.2 && lat <= 39.7 && lon >= 21.8 && lon <= 22.5) return _find("Καρδίτσης");
    if (lat >= 40.4 && lat <= 40.8 && lon >= 21.0 && lon <= 21.7) return _find("Καστοριάς");
    if (lat >= 39.5 && lat <= 39.8 && lon >= 19.8 && lon <= 20.2) return _find("Κέρκυρας");
    if (lat >= 38.1 && lat <= 38.5 && lon >= 20.3 && lon <= 20.8) return _find("Κεφαλληνίας");
    if (lat >= 40.8 && lat <= 41.2 && lon >= 22.2 && lon <= 23.0) return _find("Κιλκίς");
    if (lat >= 40.0 && lat <= 40.5 && lon >= 21.5 && lon <= 22.2) return _find("Κοζάνης");
    if (lat >= 37.7 && lat <= 38.2 && lon >= 22.5 && lon <= 23.2) return _find("Κορινθίας");
    if (lat >= 36.8 && lat <= 37.5 && lon >= 24.5 && lon <= 25.8) return _find("Κυκλάδων");
    if (lat >= 36.6 && lat <= 37.2 && lon >= 22.3 && lon <= 23.0) return _find("Λακωνίας");
    if (lat >= 39.4 && lat <= 39.9 && lon >= 22.0 && lon <= 22.8) return _find("Λαρίσης");
    if (lat >= 35.0 && lat <= 35.4 && lon >= 25.5 && lon <= 26.3) return _find("Λασιθίου");
    if (lat >= 38.9 && lat <= 39.4 && lon >= 25.8 && lon <= 26.8) return _find("Λέσβου");
    if (lat >= 38.6 && lat <= 38.9 && lon >= 20.5 && lon <= 20.9) return _find("Λευκάδος");
    if (lat >= 39.2 && lat <= 39.6 && lon >= 22.5 && lon <= 23.2) return _find("Μαγνησίας");
    if (lat >= 36.9 && lat <= 37.4 && lon >= 21.8 && lon <= 22.5) return _find("Μεσσηνίας");
    if (lat >= 41.0 && lat <= 41.5 && lon >= 24.8 && lon <= 25.5) return _find("Ξάνθης");
    if (lat >= 40.7 && lat <= 41.1 && lon >= 22.0 && lon <= 22.7) return _find("Πέλλης");
    if (lat >= 40.2 && lat <= 40.6 && lon >= 22.3 && lon <= 22.9) return _find("Πιερίας");
    if (lat >= 38.9 && lat <= 39.3 && lon >= 20.6 && lon <= 21.1) return _find("Πρέβεζας");
    if (lat >= 35.2 && lat <= 35.6 && lon >= 24.3 && lon <= 25.0) return _find("Ρεθύμνης");
    if (lat >= 41.0 && lat <= 41.5 && lon >= 25.3 && lon <= 26.1) return _find("Ροδόπης");
    if (lat >= 37.6 && lat <= 37.9 && lon >= 26.6 && lon <= 27.0) return _find("Σάμου");
    if (lat >= 41.0 && lat <= 41.5 && lon >= 23.0 && lon <= 23.8) return _find("Σερρών");
    if (lat >= 39.5 && lat <= 39.9 && lon >= 21.5 && lon <= 22.2) return _find("Τρικάλων");
    if (lat >= 38.7 && lat <= 39.2 && lon >= 22.1 && lon <= 22.9) return _find("Φθιώτιδος");
    if (lat >= 40.7 && lat <= 41.2 && lon >= 21.3 && lon <= 22.0) return _find("Φλωρίνης");
    if (lat >= 38.4 && lat <= 38.9 && lon >= 22.0 && lon <= 22.7) return _find("Φωκίδος");
    if (lat >= 40.2 && lat <= 40.7 && lon >= 23.1 && lon <= 23.9) return _find("Χαλκιδικής");
    if (lat >= 35.4 && lat <= 35.8 && lon >= 23.8 && lon <= 24.5) return _find("Χανίων");
    if (lat >= 38.3 && lat <= 38.6 && lon >= 26.0 && lon <= 26.5) return _find("Χίου");
    return all[0]; // Default Αττική
  }

  static NomosData _find(String name) {
    return all.firstWhere((n) => n.name == name, orElse: () => all[0]);
  }
}
