import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../providers/detection_provider.dart';
import '../models/anomaly_event.dart';

class AnomalyList extends StatelessWidget {
  const AnomalyList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final provider = context.watch<DetectionProvider>();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_rounded,
                color: colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Recent Anomalies',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${provider.activeAlerts} Active',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (provider.anomalyEvents.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle_rounded,
                      size: 64,
                      color: colorScheme.tertiary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No anomalies detected',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: provider.anomalyEvents.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final event = provider.anomalyEvents[index];
                return _buildAnomalyCard(context, event, colorScheme, provider);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildAnomalyCard(
    BuildContext context,
    AnomalyEvent event,
    ColorScheme colorScheme,
    DetectionProvider provider,
  ) {
    final severityColor = _getSeverityColor(event.severity, colorScheme);
    final severityIcon = _getSeverityIcon(event.severity);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: event.isResolved
            ? colorScheme.surfaceContainerHighest.withOpacity(0.3)
            : severityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: event.isResolved
              ? colorScheme.outline.withOpacity(0.2)
              : severityColor.withOpacity(0.3),
          width: event.isResolved ? 1 : 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  severityIcon,
                  color: severityColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getAnomalyTypeLabel(event.type),
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, HH:mm').format(event.timestamp),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (!event.isResolved)
                ElevatedButton(
                  onPressed: () => provider.resolveAlert(event.id),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Resolve',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.tertiaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: colorScheme.onTertiaryContainer,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Resolved',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onTertiaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            event.description,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildConfidenceBar(event.confidence, colorScheme),
              ),
              const SizedBox(width: 8),
              Text(
                '${(event.confidence * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConfidenceBar(double confidence, ColorScheme colorScheme) {
    return Container(
      height: 6,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: confidence,
        child: Container(
          decoration: BoxDecoration(
            color: confidence > 0.8
                ? colorScheme.tertiary
                : confidence > 0.6
                    ? colorScheme.primary
                    : colorScheme.secondary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }

  Color _getSeverityColor(AnomalySeverity severity, ColorScheme colorScheme) {
    switch (severity) {
      case AnomalySeverity.low:
        return colorScheme.secondary;
      case AnomalySeverity.medium:
        return colorScheme.primary;
      case AnomalySeverity.high:
        return colorScheme.error;
      case AnomalySeverity.critical:
        return const Color(0xFFDC2626);
    }
  }

  IconData _getSeverityIcon(AnomalySeverity severity) {
    switch (severity) {
      case AnomalySeverity.low:
        return Icons.info_rounded;
      case AnomalySeverity.medium:
        return Icons.warning_rounded;
      case AnomalySeverity.high:
        return Icons.error_rounded;
      case AnomalySeverity.critical:
        return Icons.dangerous_rounded;
    }
  }

  String _getAnomalyTypeLabel(AnomalyType type) {
    switch (type) {
      case AnomalyType.theftAttempt:
        return 'Theft Attempt';
      case AnomalyType.loitering:
        return 'Loitering';
      case AnomalyType.unusualMovement:
        return 'Unusual Movement';
      case AnomalyType.unauthorizedAccess:
        return 'Unauthorized Access';
      case AnomalyType.tampering:
        return 'Tampering';
      case AnomalyType.other:
        return 'Other';
    }
  }
}
