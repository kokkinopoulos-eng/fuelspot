import 'package:flutter/material.dart';
import '../../core/ai/rule_based_ai.dart';
import '../theme/app_theme.dart';

class AiInsightsPanel extends StatelessWidget {
  final List<AiInsight> insights;
  final void Function(String stationId)? onStationTap;

  const AiInsightsPanel({
    super.key,
    required this.insights,
    this.onStationTap,
  });

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
          child: Row(
            children: [
              const Icon(Icons.auto_awesome,
                  size: 15, color: AppTheme.primary),
              const SizedBox(width: 6),
              Text(
                'Έξυπνη ανάλυση',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 110,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: insights.length,
            separatorBuilder: (_, __) => const SizedBox(width: 10),
            itemBuilder: (context, i) => _InsightCard(
              insight: insights[i],
              onAction: onStationTap,
            ),
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  final AiInsight insight;
  final void Function(String stationId)? onAction;

  const _InsightCard({required this.insight, this.onAction});

  @override
  Widget build(BuildContext context) {
    final colors = _colorsFor(insight.type);

    return Container(
      width: 220,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: icon + title
          Row(
            children: [
              Icon(_iconFor(insight.type), size: 14, color: colors.accent),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  insight.title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: colors.accent,
                    letterSpacing: 0.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Highlight badge
              if (insight.highlight != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    insight.highlight!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colors.accent,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),

          // Message
          Expanded(
            child: Text(
              insight.message,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
              overflow: TextOverflow.fade,
            ),
          ),

          // Action button
          if (insight.action != null && onAction != null) ...[
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () => onAction!(insight.action!.stationId),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    insight.action!.label,
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 3),
                  Icon(Icons.arrow_forward, size: 11, color: colors.accent),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _iconFor(InsightType type) {
    switch (type) {
      case InsightType.recommendation:
        return Icons.local_gas_station;
      case InsightType.saving:
        return Icons.savings_outlined;
      case InsightType.priceLevel:
        return Icons.show_chart;
      case InsightType.trend:
        return Icons.trending_down;
      case InsightType.warning:
        return Icons.warning_amber_outlined;
    }
  }

  _CardColors _colorsFor(InsightType type) {
    switch (type) {
      case InsightType.recommendation:
        return _CardColors(
          bg: const Color(0xFFE8F5E9),
          border: const Color(0xFFA5D6A7),
          accent: const Color(0xFF2E7D32),
        );
      case InsightType.saving:
        return _CardColors(
          bg: const Color(0xFFE3F2FD),
          border: const Color(0xFF90CAF9),
          accent: const Color(0xFF1565C0),
        );
      case InsightType.priceLevel:
        return _CardColors(
          bg: const Color(0xFFFFF8E1),
          border: const Color(0xFFFFCC80),
          accent: const Color(0xFFE65100),
        );
      case InsightType.trend:
        return _CardColors(
          bg: const Color(0xFFE8EAF6),
          border: const Color(0xFF9FA8DA),
          accent: const Color(0xFF283593),
        );
      case InsightType.warning:
        return _CardColors(
          bg: const Color(0xFFFFF3E0),
          border: const Color(0xFFFFB74D),
          accent: const Color(0xFFBF360C),
        );
    }
  }
}

class _CardColors {
  final Color bg;
  final Color border;
  final Color accent;
  const _CardColors(
      {required this.bg, required this.border, required this.accent});
}



