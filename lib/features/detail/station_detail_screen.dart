import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/models/station.dart';
import '../../core/repositories/fuel_repository.dart';
import '../../shared/theme/brand_colors.dart';

class StationDetailScreen extends StatelessWidget {
  final Station station;
  final String fuelType;
  final bool isNearest;

  const StationDetailScreen({
    super.key,
    required this.station,
    required this.fuelType,
    this.isNearest = false,
  });

  @override
  Widget build(BuildContext context) {
    final repo = context.watch<FuelRepository>();
    final isFav = repo.isFavorite(station.id);
    final brand = BrandColors.of(station.brand);

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context).colorScheme.copyWith(primary: brand.primary),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: brand.primary,
            foregroundColor: brand.text,
          ),
        ),
      ),
      child: Scaffold(
        body: CustomScrollView(slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: brand.primary,
            foregroundColor: brand.text,
            actions: [
              IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                color: isFav ? Colors.red.shade300 : brand.text,
                onPressed: () => repo.toggleFavorite(station.id),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [brand.primary, brand.secondary],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 88, 20, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(children: [
                        // Brand logo
                        Container(
                          width: 56, height: 56,
                          decoration: BoxDecoration(
                            color: brand.text.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: brand.text.withValues(alpha: 0.3), width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              station.brand.isNotEmpty ? station.brand.substring(0, station.brand.length >= 3 ? 3 : station.brand.length).toUpperCase() : '⛽',
                              style: TextStyle(color: brand.text, fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isNearest) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                margin: const EdgeInsets.only(bottom: 6),
                                decoration: BoxDecoration(
                                  color: brand.accent.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(Icons.near_me, size: 12, color: brand.primary),
                                  const SizedBox(width: 4),
                                  Text('Πλησιέστερο', style: TextStyle(color: brand.primary, fontSize: 11, fontWeight: FontWeight.bold)),
                                ]),
                              ),
                            ],
                            Text(station.name, style: TextStyle(color: brand.text, fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(station.address, style: TextStyle(color: brand.text.withValues(alpha: 0.8), fontSize: 13)),
                            if (station.distanceKm != null) ...[
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: brand.text.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  station.distanceKm! < 1 ? '${(station.distanceKm!*1000).round()}m μακριά' : '${station.distanceKm!.toStringAsFixed(1)}km μακριά',
                                  style: TextStyle(color: brand.text, fontSize: 11, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ],
                        )),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              // Τιμές

              const SizedBox(height: 24),

              // Mini χάρτης
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  height: 180,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(station.lat, station.lon),
                      initialZoom: 15.5,
                      interactionOptions: const InteractionOptions(flags: InteractiveFlag.none),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'gr.webdevelopment.fuelspot',
                      ),
                      MarkerLayer(markers: [
                        Marker(
                          point: LatLng(station.lat, station.lon),
                          width: 40, height: 40,
                          child: Icon(Icons.location_pin, size: 40, color: brand.primary),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Πληροφορίες
              if (station.operator.isNotEmpty || station.phone.isNotEmpty || station.openingHours.isNotEmpty) ...[
                Text('Πληροφορίες', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: brand.primary)),
                const SizedBox(height: 10),
                if (station.operator.isNotEmpty)
                  _infoRow(Icons.business, 'Υπεύθυνος', station.operator, brand),
                if (station.phone.isNotEmpty)
                  InkWell(
                    onTap: () async {
                      final uri = Uri.parse('tel:' + station.phone.replaceAll(' ', ''));
                      if (await canLaunchUrl(uri)) await launchUrl(uri);
                    },
                    child: _infoRow(Icons.phone, 'Τηλέφωνο', station.phone, brand, isLink: true),
                  ),
                if (station.openingHours.isNotEmpty)
                  _infoRow(Icons.schedule, 'Ωράριο', _formatHours(station.openingHours), brand),
                const SizedBox(height: 16),
              ],

              // Buttons
              Row(children: [
                Expanded(child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text('Οδηγίες'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: brand.primary,
                    foregroundColor: brand.text,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  onPressed: () async {
                    final uri = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${station.lat},${station.lon}');
                    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
                  },
                )),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: brand.primary.withValues(alpha: 0.4)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                    color: isFav ? Colors.red : brand.primary,
                    onPressed: () => repo.toggleFavorite(station.id),
                  ),
                ),
              ]),
              const SizedBox(height: 32),
            ]),
          )),
        ]),
      ),
    );
  }


  Widget _infoRow(IconData icon, String label, String value, BrandTheme brand, {bool isLink = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: brand.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: brand.primary),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          Text(value, style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isLink ? brand.primary : Colors.black87,
            decoration: isLink ? TextDecoration.underline : null,
          )),
        ])),
      ]),
    );
  }

  String _formatHours(String hours) {
    if (hours == '24/7') return 'Ανοιχτό 24 ώρες';
    return hours
        .replaceAll('Mo', 'Δευ').replaceAll('Tu', 'Τρι').replaceAll('We', 'Τετ')
        .replaceAll('Th', 'Πεμ').replaceAll('Fr', 'Παρ').replaceAll('Sa', 'Σαβ')
        .replaceAll('Su', 'Κυρ').replaceAll('off', 'κλειστά');
  }
}
