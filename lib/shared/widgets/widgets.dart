import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../theme/brand_colors.dart';
import 'brand_logo.dart';
import '../../core/models/station.dart';

class PriceBadge extends StatelessWidget {
  final double? price;
  final int rank;
  final int total;
  final bool large;
  const PriceBadge({super.key, required this.price, this.rank = 0, this.total = 1, this.large = false});

  @override
  Widget build(BuildContext context) {
    if (price == null) return const SizedBox.shrink();
    final color = AppTheme.priceColor(rank, total);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: large ? 14 : 10, vertical: large ? 8 : 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.4), width: 1.5),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('€${price!.toStringAsFixed(3)}', style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: large ? 22 : 15)),
        Text('/λίτρο', style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: large ? 10 : 9)),
      ]),
    );
  }
}

class StationCard extends StatelessWidget {
  final Station station;
  final String fuelType;
  final int rank;
  final int total;
  final bool isFavorite;
  final bool isNearest;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const StationCard({
    super.key,
    required this.station,
    required this.fuelType,
    required this.rank,
    required this.total,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
    this.isNearest = false,
  });

  @override
  Widget build(BuildContext context) {
    final price = station.priceFor(fuelType);
    final dist = station.distanceKm;
    final brand = BrandColors.of(station.brand);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isNearest ? brand.primary.withValues(alpha: 0.6) : Colors.grey.shade200,
          width: isNearest ? 2 : 1,
        ),
        boxShadow: [BoxShadow(
          color: isNearest ? brand.primary.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.06),
          blurRadius: isNearest ? 12 : 8,
          offset: const Offset(0, 3),
        )],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Column(children: [
            // Nearest banner
            if (isNearest)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: brand.primary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                ),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.near_me, size: 13, color: brand.text),
                  const SizedBox(width: 5),
                  Text('Πλησιέστερο πρατήριο',
                      style: TextStyle(color: brand.text, fontSize: 12, fontWeight: FontWeight.bold)),
                ]),
              ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(children: [
                // Brand logo
                BrandLogo(brand: station.brand, size: 48),
                const SizedBox(width: 12),
                // Info
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    Expanded(child: Text(station.name,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                        overflow: TextOverflow.ellipsis)),
                    GestureDetector(
                      onTap: onFavorite,
                      child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey.shade300, size: 18),
                    ),
                  ]),
                  if (station.address.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Row(children: [
                      Icon(Icons.location_on, size: 12, color: Colors.grey.shade400),
                      const SizedBox(width: 3),
                      Expanded(child: Text(station.address,
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                          overflow: TextOverflow.ellipsis)),
                    ]),
                  ],
                  if (dist != null) ...[
                    const SizedBox(height: 3),
                    Row(children: [
                      Icon(Icons.directions_walk, size: 12, color: brand.primary.withValues(alpha: 0.7)),
                      const SizedBox(width: 3),
                      Text(
                        dist < 1 ? '${(dist * 1000).round()}m μακριά' : '${dist.toStringAsFixed(1)}km μακριά',
                        style: TextStyle(color: brand.primary, fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ]),
                  ],
                ])),
                // Price — μόνο αν υπάρχει πραγματική τιμή
                if (price != null) ...[
                  const SizedBox(width: 10),
                  PriceBadge(price: price, rank: rank, total: total),
                ],
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

class FuelTypeSelector extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const FuelTypeSelector({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        children: FuelType.all.map((type) {
          final isSelected = type == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(FuelType.label(type)),
              selected: isSelected,
              onSelected: (_) => onChanged(type),
              selectedColor: AppTheme.primary,
              backgroundColor: Colors.white,
              side: BorderSide(color: isSelected ? AppTheme.primary : Colors.grey.shade300),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class LocationBar extends StatelessWidget {
  final String statusText;
  final double? accuracy;
  final bool isLocating;
  final VoidCallback onRefresh;
  const LocationBar({super.key, required this.statusText, this.accuracy, this.isLocating = false, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4)],
      ),
      child: Row(children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: isLocating ? Colors.orange.withValues(alpha: 0.1) : AppTheme.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            isLocating ? Icons.gps_not_fixed : Icons.gps_fixed,
            size: 16,
            color: isLocating ? Colors.orange : AppTheme.primary,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(statusText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          if (accuracy != null && isLocating)
            Text('Ακρίβεια: ${accuracy!.round()}m',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
        ])),
        if (isLocating)
          const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
        else
          Container(
            decoration: BoxDecoration(
              color: AppTheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh, size: 18),
              color: AppTheme.primary,
              onPressed: onRefresh,
              padding: const EdgeInsets.all(6),
              constraints: const BoxConstraints(),
            ),
          ),
      ]),
    );
  }
}
