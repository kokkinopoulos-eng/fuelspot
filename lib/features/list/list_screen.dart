import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/ai/rule_based_ai.dart';
import '../../core/api/location_service.dart';
import '../../core/repositories/fuel_repository.dart';
import '../../shared/widgets/ai_insights_panel.dart';
import '../../shared/widgets/widgets.dart';
import '../detail/station_detail_screen.dart';
import '../../shared/widgets/nomos_panel.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});
  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  Future<void> _loadData() async {
    final loc = context.read<LocationService>();
    final repo = context.read<FuelRepository>();
    await loc.getAccuratePosition();
    if (loc.current != null) await repo.loadNearby(loc.current!);
  }

  @override
  Widget build(BuildContext context) {
    final loc = context.watch<LocationService>();
    final repo = context.watch<FuelRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('FuelSpot'),
        actions: [IconButton(icon: const Icon(Icons.tune), onPressed: () => _showRadiusSheet(context, repo))],
      ),
      body: Column(children: [
        LocationBar(
          statusText: _locationText(loc),
          accuracy: loc.currentAccuracy < 9999 ? loc.currentAccuracy : null,
          isLocating: loc.status == LocationStatus.acquiring,
          onRefresh: _loadData,
        ),
        const Divider(height: 1),
        const SizedBox(height: 8),
        if (loc.current != null) NomosPanel(lat: loc.current!.lat, lon: loc.current!.lon),
        FuelTypeSelector(selected: repo.selectedFuelType, onChanged: (t) => repo.setFuelType(t)),
        const SizedBox(height: 8),
        if (repo.stations.isNotEmpty) ...[
          AiInsightsPanel(
            insights: RuleBasedAi.analyze(stations: repo.stations, fuelType: repo.selectedFuelType),
            onStationTap: (id) {
              final station = repo.stations.firstWhere((s) => s.id == id);
              Navigator.push(context, MaterialPageRoute(builder: (_) => StationDetailScreen(
                station: station, fuelType: repo.selectedFuelType,
                isNearest: repo.stations.indexOf(station) == 0,
              )));
            },
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(children: [
              Icon(Icons.info_outline, size: 13, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text(
                '${repo.stations.length} πρατήρια · τιμές: μέσος νομού',
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
            ]),
          ),
        ],
        Expanded(child: _buildBody(repo, loc)),
      ]),
    );
  }

  Widget _buildBody(FuelRepository repo, LocationService loc) {
    if (loc.status == LocationStatus.denied) return _ErrorState(icon: Icons.location_off, message: loc.errorMessage ?? 'Δεν επιτράπηκε η πρόσβαση.', action: 'Ρυθμίσεις', onAction: loc.openSettings);
    if (repo.loading) return const Center(child: CircularProgressIndicator());
    if (repo.error != null) return _ErrorState(icon: Icons.wifi_off, message: repo.error!, action: 'Δοκίμασε ξανά', onAction: _loadData);
    if (repo.stations.isEmpty) return const _ErrorState(icon: Icons.local_gas_station, message: 'Δεν βρέθηκαν πρατήρια στην περιοχή σου.');
    return RefreshIndicator(
      onRefresh: _loadData,
      child: ListView.builder(
        itemCount: repo.stations.length,
        itemBuilder: (context, i) {
          final station = repo.stations[i];
          final isNearest = i == 0;
          return StationCard(
            station: station,
            fuelType: repo.selectedFuelType,
            rank: i,
            total: repo.stations.length,
            isFavorite: repo.isFavorite(station.id),
            isNearest: isNearest,
            onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => StationDetailScreen(
                station: station,
                fuelType: repo.selectedFuelType,
                isNearest: isNearest,
              ),
            )),
            onFavorite: () => repo.toggleFavorite(station.id),
          );
        },
      ),
    );
  }

  String _locationText(LocationService loc) {
    switch (loc.status) {
      case LocationStatus.idle: return 'Εντοπισμός θέσης...';
      case LocationStatus.requesting: return 'Ζητείται άδεια...';
      case LocationStatus.acquiring: return 'Εντοπισμός GPS...';
      case LocationStatus.ready:
        final src = loc.current?.source;
        if (src == LocationSource.cached) return 'Χρήση τελευταίας θέσης';
        if (src == LocationSource.manual) return 'Χειροκίνητη τοποθεσία';
        return 'Θέση εντοπίστηκε ✓';
      case LocationStatus.error: return loc.errorMessage ?? 'Σφάλμα εντοπισμού';
      case LocationStatus.denied: return 'Δεν επιτράπηκε η τοποθεσία';
    }
  }

  void _showRadiusSheet(BuildContext context, FuelRepository repo) {
    showModalBottomSheet(context: context, builder: (_) => Padding(
      padding: const EdgeInsets.all(24),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Ακτίνα αναζήτησης', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Wrap(spacing: 10, children: [1.0, 2.0, 5.0, 10.0].map((km) => ChoiceChip(
          label: Text('${km.round()}km'), selected: km == repo.radiusKm,
          onSelected: (_) {
            repo.setRadius(km);
            final loc = context.read<LocationService>();
            if (loc.current != null) repo.loadNearby(loc.current!);
            Navigator.pop(context);
          },
        )).toList()),
        const SizedBox(height: 16),
      ]),
    ));
  }
}

class _ErrorState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? action;
  final VoidCallback? onAction;
  const _ErrorState({required this.icon, required this.message, this.action, this.onAction});

  @override
  Widget build(BuildContext context) {
    return Center(child: Padding(padding: const EdgeInsets.all(32), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 64, color: Colors.grey.shade300),
      const SizedBox(height: 16),
      Text(message, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade600)),
      if (action != null && onAction != null) ...[
        const SizedBox(height: 20),
        ElevatedButton(onPressed: onAction, child: Text(action!)),
      ],
    ])));
  }
}
