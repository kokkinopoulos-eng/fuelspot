import 'package:flutter/material.dart';
import '../../core/data/remote_prices_service.dart';
import '../../core/data/nomos_prices.dart';
import '../theme/app_theme.dart';

class NomosPanel extends StatefulWidget {
  final double lat;
  final double lon;
  const NomosPanel({super.key, required this.lat, required this.lon});

  @override
  State<NomosPanel> createState() => _NomosPanelState();
}

class _NomosPanelState extends State<NomosPanel> {
  late NomosData _selected;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _selected = NomosRepository.detectNomos(widget.lat, widget.lon);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.primary.withValues(alpha: 0.2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.local_gas_station, size: 16, color: AppTheme.primary),
              ),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text('Μέσες τιμές • ', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  Text(_selected.name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primary)),
                ]),
                const SizedBox(height: 4),
                Wrap(spacing: 6, children: [
                  _chip('95', _selected.unleaded95),
                  _chip('DSL', _selected.diesel),
                  _chip('98', _selected.unleaded98),
                  _chip('LPG', _selected.lpg),
                ]),
              ])),
              Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey.shade400, size: 20),
            ]),
          ),
        ),
        if (_expanded) ...[
          const Divider(height: 1),
          SizedBox(
            height: 220,
            child: ListView.builder(
              itemCount: RemotePricesService.current.length,
              itemBuilder: (context, i) {
                final nomos = RemotePricesService.current[i];
                final isSel = nomos.name == _selected.name;
                return InkWell(
                  onTap: () => setState(() { _selected = nomos; _expanded = false; }),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(children: [
                      SizedBox(width: 20, child: isSel ? Icon(Icons.check, size: 14, color: AppTheme.primary) : null),
                      const SizedBox(width: 4),
                      Expanded(child: Text(nomos.name, style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                        color: isSel ? AppTheme.primary : Colors.black87,
                      ))),
                      Text('€${nomos.unleaded95?.toStringAsFixed(3) ?? "-"}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ]),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Row(children: [
              Icon(Icons.info_outline, size: 11, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text('Πηγή: ΥΠΑΝ ${RemotePricesService.date}',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _chip(String label, double? price) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
    child: Text('$label: €${price?.toStringAsFixed(3) ?? "-"}',
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
  );
}
