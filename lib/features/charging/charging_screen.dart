import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../core/api/charging_api_client.dart';
import '../../core/api/location_service.dart';
import '../../core/models/charging_station.dart';

class ChargingScreen extends StatefulWidget {
  const ChargingScreen({super.key});
  @override
  State<ChargingScreen> createState() => _ChargingScreenState();
}

class _ChargingScreenState extends State<ChargingScreen> {
  final _api = ChargingApiClient();
  List<ChargingStation> _stations = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final loc = context.read<LocationService>();
      final pos = await loc.getAccuratePosition();
      if (pos == null) {
        setState(() { _error = 'Δεν βρέθηκε τοποθεσία'; _loading = false; });
        return;
      }
      final stations = await _api.getNearbyStations(lat: pos.lat, lon: pos.lon);
      stations.sort((a, b) {
        final da = _dist(pos.lat, pos.lon, a.lat, a.lon);
        final db = _dist(pos.lat, pos.lon, b.lat, b.lon);
        a.distanceKm = da;
        b.distanceKm = db;
        return da.compareTo(db);
      });
      setState(() { _stations = stations; _loading = false; });
    } catch (e) {
      setState(() { _error = e.toString(); _loading = false; });
    }
  }

  double _dist(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = (lat2 - lat1) * 3.14159265 / 180;
    final dLon = (lon2 - lon1) * 3.14159265 / 180;
    final a = dLat * dLat + dLon * dLon;
    return r * (a < 0 ? -a : a).abs() * 0.5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Σημεία Φόρτισης'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  Text(_error!, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: _load, child: const Text('Επανάληψη')),
                ]))
              : _stations.isEmpty
                  ? const Center(child: Text('Δεν βρέθηκαν σταθμοί φόρτισης κοντά σας'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _stations.length,
                      itemBuilder: (ctx, i) => _ChargingCard(station: _stations[i]),
                    ),
    );
  }
}

class _ChargingCard extends StatelessWidget {
  final ChargingStation station;
  const _ChargingCard({required this.station});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            const Icon(Icons.ev_station, color: Color(0xFF2E7D32), size: 28),
            const SizedBox(width: 10),
            Expanded(child: Text(station.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
            if (station.distanceKm != null)
              Text('${station.distanceKm!.toStringAsFixed(1)} km',
                  style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ]),
          if (station.operator.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(station.operator, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          ],
          if (station.address.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(child: Text(station.address,
                  style: const TextStyle(fontSize: 13, color: Colors.grey))),
            ]),
          ],
          if (station.connectors.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(spacing: 6, children: station.connectors.map((c) => Chip(
              label: Text(c, style: const TextStyle(fontSize: 11, color: Color(0xFF2E7D32), fontWeight: FontWeight.bold)),
              backgroundColor: const Color(0xFFE8F5E9),
              padding: EdgeInsets.zero,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            )).toList()),
          ],
          if (station.capacity != null) ...[
            const SizedBox(height: 4),
            Text('${station.capacity} θέσεις',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
          if (station.openingHours.isNotEmpty) ...[
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.access_time, size: 13, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(child: Text(station.openingHours,
                  style: const TextStyle(fontSize: 12, color: Colors.grey))),
            ]),
          ],
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              icon: const Icon(Icons.directions, size: 16),
              label: const Text('Οδηγίες', style: TextStyle(fontSize: 13)),
              onPressed: () async {
                final url = Uri.parse(
                  'https://www.google.com/maps/dir/?api=1&destination=${station.lat},${station.lon}&travelmode=driving');
                if (await canLaunchUrl(url)) await launchUrl(url, mode: LaunchMode.externalApplication);
              },
            )),
            const SizedBox(width: 8),
            Expanded(child: OutlinedButton.icon(
              icon: const Icon(Icons.electric_bolt, size: 16),
              label: const Text('OpenChargeMap', style: TextStyle(fontSize: 13)),
              style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFF2E7D32)),
              onPressed: () async {
                final url = Uri.parse(
                  'https://www.google.com/maps/search/charging+station/@${station.lat},${station.lon},15z');
                await launchUrl(url, mode: LaunchMode.externalApplication);
              },
            )),
          ]),
          const SizedBox(height: 6),
          const Text(
            'Για πραγματική διαθεσιμότητα χρησιμοποιήστε το PlugShare.',
            style: TextStyle(fontSize: 11, color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ]),
      ),
    );
  }
}
