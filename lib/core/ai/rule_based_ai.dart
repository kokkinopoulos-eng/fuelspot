import '../models/station.dart';

/// Αποτέλεσμα AI ανάλυσης
class AiInsight {
  final InsightType type;
  final String title;
  final String message;
  final String? highlight; // αριθμός/τιμή που ξεχωρίζει
  final String? highlightUnit;
  final AiAction? action;

  const AiInsight({
    required this.type,
    required this.title,
    required this.message,
    this.highlight,
    this.highlightUnit,
    this.action,
  });
}

enum InsightType { recommendation, saving, priceLevel, trend, warning }

class AiAction {
  final String label;
  final String stationId; // για navigation
  const AiAction({required this.label, required this.stationId});
}

/// Εθνικοί μέσοι όροι — ενημερώνονται από backend αργότερα
/// Τρέχουσες τιμές Ιούνιος 2025 (Ελλάδα)
class NationalAverages {
  static const Map<String, double> prices = {
    FuelType.unleaded95: 1.820,
    FuelType.unleaded98: 1.940,
    FuelType.diesel: 1.720,
    FuelType.lpg: 0.920,
  };
}

/// Rule-based AI — δεν χρειάζεται LLM, δουλεύει offline σε κάθε Android
class RuleBasedAi {
  /// Κύρια συνάρτηση — επιστρέφει λίστα insights για τα κοντινά πρατήρια
  static List<AiInsight> analyze({
    required List<Station> stations,
    required String fuelType,
    double? tankLiters, // προαιρετικά — για υπολογισμό εξοικονόμησης
  }) {
    if (stations.isEmpty) return [];

    final insights = <AiInsight>[];
    final withPrice = stations.where((s) => s.priceFor(fuelType) != null).toList();
    if (withPrice.isEmpty) return [];

    // Ταξινόμηση by price (ήδη ταξινομημένα από repository, αλλά ασφαλές)
    withPrice.sort((a, b) =>
        a.priceFor(fuelType)!.compareTo(b.priceFor(fuelType)!));

    final cheapest = withPrice.first;
    final cheapestPrice = cheapest.priceFor(fuelType)!;
    final national = NationalAverages.prices[fuelType];

    // ── 1. Σύσταση πρατηρίου ─────────────────────────────────────────────
    insights.add(_buildRecommendation(cheapest, fuelType, withPrice));

    // ── 2. Εξοικονόμηση vs ακριβύτερο ────────────────────────────────────
    if (withPrice.length >= 2) {
      final mostExpensive = withPrice.last;
      final saving = _savingInsight(
        cheapest: cheapest,
        mostExpensive: mostExpensive,
        fuelType: fuelType,
        tankLiters: tankLiters ?? 50.0,
      );
      if (saving != null) insights.add(saving);
    }

    // ── 3. Επίπεδο τιμής vs εθνικό μέσο ─────────────────────────────────
    if (national != null) {
      insights.add(_priceLevelInsight(cheapestPrice, national, fuelType));
    }

    // ── 4. Προειδοποίηση αν όλες οι τιμές ψηλά ──────────────────────────
    final avgLocal = withPrice
            .map((s) => s.priceFor(fuelType)!)
            .reduce((a, b) => a + b) /
        withPrice.length;

    if (national != null && avgLocal > national * 1.05) {
      insights.add(const AiInsight(
        type: InsightType.warning,
        title: 'Ακριβή περιοχή',
        message: 'Τα πρατήρια στην περιοχή σου είναι πάνω από τον εθνικό μέσο. '
            'Αν μπορείς, αναζήτησε σε μεγαλύτερη ακτίνα.',
      ));
    }

    // ── 5. Best value — φθηνό + κοντά ────────────────────────────────────
    final bestValue = _bestValueStation(withPrice, fuelType);
    if (bestValue != null && bestValue.id != cheapest.id) {
      insights.add(_buildBestValue(bestValue, fuelType));
    }

    return insights;
  }

  // ─── Builders ─────────────────────────────────────────────────────────────

  static AiInsight _buildRecommendation(
      Station s, String fuelType, List<Station> all) {
    final price = s.priceFor(fuelType)!;
    final dist = s.distanceKm;
    final distText = dist != null
        ? dist < 1
            ? '${(dist * 1000).round()}m από σένα'
            : '${dist.toStringAsFixed(1)}km από σένα'
        : '';

    return AiInsight(
      type: InsightType.recommendation,
      title: 'Φθηνότερη επιλογή',
      message: '${s.name}${distText.isNotEmpty ? ' · $distText' : ''}. '
          '${all.length > 1 ? 'Φθηνότερο από ${all.length - 1} άλλα πρατήρια.' : ''}',
      highlight: '€${price.toStringAsFixed(3)}',
      highlightUnit: '/L',
      action: AiAction(label: 'Πήγαινέ με', stationId: s.id),
    );
  }

  static AiInsight? _savingInsight({
    required Station cheapest,
    required Station mostExpensive,
    required String fuelType,
    required double tankLiters,
  }) {
    final priceDiff =
        mostExpensive.priceFor(fuelType)! - cheapest.priceFor(fuelType)!;
    if (priceDiff < 0.01) return null; // αμελητέα διαφορά

    final savingEur = priceDiff * tankLiters;

    return AiInsight(
      type: InsightType.saving,
      title: 'Εξοικονόμηση',
      message: 'Με ${tankLiters.round()}L στο ${cheapest.name} γλιτώνεις '
          '€${savingEur.toStringAsFixed(2)} σε σχέση με το ακριβύτερο κοντινό.',
      highlight: '€${savingEur.toStringAsFixed(2)}',
      highlightUnit: 'ανά γέμισμα',
    );
  }

  static AiInsight _priceLevelInsight(
      double localPrice, double national, String fuelType) {
    final diffPct = ((localPrice - national) / national * 100);
    final absDiff = (localPrice - national).abs();
    final fuelLabel = FuelType.label(fuelType);

    if (diffPct <= -3) {
      return AiInsight(
        type: InsightType.priceLevel,
        title: 'Κάτω από μέσο όρο',
        message: 'Η τιμή $fuelLabel εδώ είναι ${diffPct.abs().toStringAsFixed(1)}% '
            'χαμηλότερη από τον εθνικό μέσο (€${national.toStringAsFixed(3)}/L). '
            'Καλή στιγμή για γέμισμα!',
        highlight: '-${absDiff.toStringAsFixed(3)}€',
        highlightUnit: 'vs εθνικό',
      );
    } else if (diffPct >= 3) {
      return AiInsight(
        type: InsightType.priceLevel,
        title: 'Πάνω από μέσο όρο',
        message: 'Η τοπική τιμή $fuelLabel είναι ${diffPct.toStringAsFixed(1)}% '
            'υψηλότερη από τον εθνικό μέσο (€${national.toStringAsFixed(3)}/L).',
        highlight: '+${absDiff.toStringAsFixed(3)}€',
        highlightUnit: 'vs εθνικό',
      );
    } else {
      return AiInsight(
        type: InsightType.priceLevel,
        title: 'Κοντά στον μέσο όρο',
        message: 'Η τιμή $fuelLabel στην περιοχή σου είναι σχεδόν ίδια '
            'με τον εθνικό μέσο (€${national.toStringAsFixed(3)}/L).',
        highlight: '≈ μέσος',
        highlightUnit: 'εθνικός',
      );
    }
  }

  /// Best value = score που συνδυάζει τιμή + απόσταση
  /// score = normalizedPrice * 0.7 + normalizedDistance * 0.3
  static Station? _bestValueStation(List<Station> stations, String fuelType) {
    final withDist =
        stations.where((s) => s.distanceKm != null).toList();
    if (withDist.length < 2) return null;

    final prices = withDist.map((s) => s.priceFor(fuelType)!).toList();
    final dists = withDist.map((s) => s.distanceKm!).toList();

    final minP = prices.reduce((a, b) => a < b ? a : b);
    final maxP = prices.reduce((a, b) => a > b ? a : b);
    final minD = dists.reduce((a, b) => a < b ? a : b);
    final maxD = dists.reduce((a, b) => a > b ? a : b);

    final pRange = maxP - minP;
    final dRange = maxD - minD;

    Station? best;
    double bestScore = double.infinity;

    for (final s in withDist) {
      final np = pRange > 0 ? (s.priceFor(fuelType)! - minP) / pRange : 0.0;
      final nd = dRange > 0 ? (s.distanceKm! - minD) / dRange : 0.0;
      final score = np * 0.7 + nd * 0.3;
      if (score < bestScore) {
        bestScore = score;
        best = s;
      }
    }

    return best;
  }

  static AiInsight _buildBestValue(Station s, String fuelType) {
    final price = s.priceFor(fuelType)!;
    final dist = s.distanceKm!;
    return AiInsight(
      type: InsightType.recommendation,
      title: 'Best value — τιμή & απόσταση',
      message: '${s.name} προσφέρει την καλύτερη ισορροπία τιμής '
          '(€${price.toStringAsFixed(3)}/L) και απόστασης '
          '(${dist < 1 ? '${(dist * 1000).round()}m' : '${dist.toStringAsFixed(1)}km"'}).',
      highlight: '€${price.toStringAsFixed(3)}',
      highlightUnit: '/L',
      action: AiAction(label: 'Δες το', stationId: s.id),
    );
  }
}
