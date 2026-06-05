import 'package:flutter/material.dart';
import '../../shared/widgets/bg_scaffold.dart';
import 'package:provider/provider.dart';
import '../../core/api/location_service.dart';
import '../../core/data/nomos_prices.dart';
import '../../shared/theme/app_theme.dart';

class PricesScreen extends StatefulWidget {
  const PricesScreen({super.key});
  @override
  State<PricesScreen> createState() => _PricesScreenState();
}

class _PricesScreenState extends State<PricesScreen> {
  NomosData? _selected;
  String _search = '';

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocationService>();
    final detected = loc.current != null
        ? NomosRepository.detectNomos(loc.current!.lat, loc.current!.lon)
        : NomosRepository.all[0];
    final current = _selected ?? detected;

    final filtered = NomosRepository.all
        .where((n) => _search.isEmpty || n.name.toLowerCase().contains(_search.toLowerCase()))
        .toList();

    return BgScaffold(
      appBar: AppBar(title: const Text('Μέσες Τιμές')),
      body: Column(children: [
        Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppTheme.primary, AppTheme.primary.withValues(alpha: 0.8)],
              begin: Alignment.topLeft, end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.location_on, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text('Νομός ${current.name}',
                  style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
              if (current.name == detected.name) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCC00),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text('Εδώ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF0D3F6B))),
                ),
              ],
            ]),
            const SizedBox(height: 14),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _bigPrice('Αμόλυβδη 95', current.unleaded95),
              _bigPrice('Diesel', current.diesel),
            ]),
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              _bigPrice('Αμόλυβδη 98', current.unleaded98),
              _bigPrice('LPG', current.lpg),
            ]),
            const SizedBox(height: 10),
            Text('Πηγή: Παρατηρητήριο ΥΠΑΝ • ${NomosRepository.dataDate}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            onChanged: (v) => setState(() => _search = v),
            decoration: InputDecoration(
              hintText: 'Αναζήτηση νομού...',
              prefixIcon: const Icon(Icons.search, size: 20),
              isDense: true,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
        ),
        // Υψηλότερος / Χαμηλότερος νομός
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(children: [
            Expanded(child: _extremeCard(
              label: 'Φθηνότερος νομός',
              nomos: NomosRepository.all.reduce((a, b) => (a.unleaded95 ?? 999) < (b.unleaded95 ?? 999) ? a : b),
              isLow: true,
            )),
            const SizedBox(width: 8),
            Expanded(child: _extremeCard(
              label: 'Ακριβότερος νομός',
              nomos: NomosRepository.all.reduce((a, b) => (a.unleaded95 ?? 0) > (b.unleaded95 ?? 0) ? a : b),
              isLow: false,
            )),
          ]),
        ),
        const SizedBox(height: 8),
        Expanded(child: ListView.builder(
          itemCount: filtered.length,
          itemBuilder: (context, i) {
            final nomos = filtered[i];
            final isSel = nomos.name == current.name;
            return InkWell(
              onTap: () => setState(() => _selected = nomos),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSel ? AppTheme.primary.withValues(alpha: 0.08) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isSel ? AppTheme.primary.withValues(alpha: 0.4) : Colors.grey.shade200),
                ),
                child: Row(children: [
                  Expanded(child: Text(nomos.name, style: TextStyle(
                    fontSize: 14,
                    fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                    color: isSel ? AppTheme.primary : Colors.black87,
                  ))),
                  Text('95: €${nomos.unleaded95?.toStringAsFixed(3) ?? "-"}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 10),
                  Text('DSL: €${nomos.diesel?.toStringAsFixed(3) ?? "-"}',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ]),
              ),
            );
          },
        )),
      ]),
    );
  }

  Widget _extremeCard({required String label, required NomosData nomos, required bool isLow}) {
    final color = isLow ? const Color(0xFF2ECC71) : const Color(0xFFE74C3C);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(isLow ? Icons.arrow_downward : Icons.arrow_upward, size: 14, color: color),
          const SizedBox(width: 4),
          Expanded(child: Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))),
        ]),
        const SizedBox(height: 6),
        Text(nomos.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        const SizedBox(height: 4),
        _priceRow('95', nomos.unleaded95),
        _priceRow('98', nomos.unleaded98),
        _priceRow('DSL', nomos.diesel),
        _priceRow('LPG', nomos.lpg),
      ]),
    );
  }

  Widget _priceRow(String label, double? price) {
    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        Text('€${price?.toStringAsFixed(3) ?? "-"}',
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _bigPrice(String label, double? price) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
      Text('€${price?.toStringAsFixed(3) ?? "-"}',
          style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
    ]);
  }
}
