import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/detection_provider.dart';
import '../widgets/dashboard_card.dart';
import '../widgets/camera_feed_grid.dart';
import '../widgets/anomaly_list.dart';
import '../widgets/statistics_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colorScheme.brightness == Brightness.light
                ? [
                    colorScheme.primary.withOpacity(0.05),
                    colorScheme.surface,
                  ]
                : [
                    colorScheme.primary.withOpacity(0.1),
                    colorScheme.surface,
                  ],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              _buildNavigationRail(context, colorScheme),
              Expanded(
                child: _buildContent(context, colorScheme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationRail(BuildContext context, ColorScheme colorScheme) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: colorScheme.outline.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildNavIcon(
            icon: Icons.dashboard_rounded,
            index: 0,
            colorScheme: colorScheme,
            label: 'Dashboard',
          ),
          _buildNavIcon(
            icon: Icons.videocam_rounded,
            index: 1,
            colorScheme: colorScheme,
            label: 'Cameras',
          ),
          _buildNavIcon(
            icon: Icons.warning_rounded,
            index: 2,
            colorScheme: colorScheme,
            label: 'Alerts',
          ),
          _buildNavIcon(
            icon: Icons.analytics_rounded,
            index: 3,
            colorScheme: colorScheme,
            label: 'Analytics',
          ),
          const Spacer(),
          _buildNavIcon(
            icon: Icons.settings_rounded,
            index: 4,
            colorScheme: colorScheme,
            label: 'Settings',
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNavIcon({
    required IconData icon,
    required int index,
    required ColorScheme colorScheme,
    required String label,
  }) {
    final isSelected = _selectedIndex == index;
    return Tooltip(
      message: label,
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            size: 28,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ColorScheme colorScheme) {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard(context, colorScheme);
      case 1:
        return _buildCameras(context, colorScheme);
      case 2:
        return _buildAlerts(context, colorScheme);
      case 3:
        return _buildAnalytics(context, colorScheme);
      case 4:
        return _buildSettings(context, colorScheme);
      default:
        return _buildDashboard(context, colorScheme);
    }
  }

  Widget _buildDashboard(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colorScheme),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'Active Cameras',
                  value: '4',
                  icon: Icons.videocam_rounded,
                  color: colorScheme.primary,
                  trend: '+2',
                ).animate().fadeIn().slideX(),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DashboardCard(
                  title: 'Total Alerts',
                  value: '156',
                  icon: Icons.warning_rounded,
                  color: colorScheme.error,
                  trend: '+12',
                ).animate().fadeIn().slideX(delay: 100.ms),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DashboardCard(
                  title: 'Detection Rate',
                  value: '94.5%',
                  icon: Icons.check_circle_rounded,
                  color: colorScheme.tertiary,
                  trend: '+2.3%',
                ).animate().fadeIn().slideX(delay: 200.ms),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DashboardCard(
                  title: 'False Positives',
                  value: '3.2%',
                  icon: Icons.info_rounded,
                  color: colorScheme.secondary,
                  trend: '-0.8%',
                ).animate().fadeIn().slideX(delay: 300.ms),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: CameraFeedGrid().animate().fadeIn().slideY(),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: AnomalyList().animate().fadeIn().slideY(delay: 100.ms),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCameras(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colorScheme, title: 'Camera Feeds'),
          const SizedBox(height: 24),
          CameraFeedGrid(),
        ],
      ),
    );
  }

  Widget _buildAlerts(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colorScheme, title: 'Anomaly Alerts'),
          const SizedBox(height: 24),
          AnomalyList(),
        ],
      ),
    );
  }

  Widget _buildAnalytics(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colorScheme, title: 'Analytics'),
          const SizedBox(height: 24),
          StatisticsPanel(),
        ],
      ),
    );
  }

  Widget _buildSettings(BuildContext context, ColorScheme colorScheme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context, colorScheme, title: 'Settings'),
          const SizedBox(height: 24),
          _buildSettingsCard(context, colorScheme),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, ColorScheme colorScheme,
      {String title = 'Dashboard'}) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const Spacer(),
        Consumer<DetectionProvider>(
          builder: (context, provider, child) {
            return ElevatedButton.icon(
              onPressed: () => provider.toggleMonitoring(),
              icon: Icon(
                provider.isMonitoring
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
              ),
              label: Text(provider.isMonitoring ? 'Pause' : 'Start Monitoring'),
              style: ElevatedButton.styleFrom(
                backgroundColor: provider.isMonitoring
                    ? colorScheme.error
                    : colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSettingsCard(BuildContext context, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Text(
            'Detection Settings',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          _buildSettingItem(
            context,
            colorScheme,
            'Confidence Threshold',
            '0.75',
            'Minimum confidence for anomaly detection',
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            context,
            colorScheme,
            'Alert Severity',
            'Medium',
            'Minimum severity to trigger alerts',
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            context,
            colorScheme,
            'Auto-Resolve Time',
            '24 hours',
            'Time before auto-resolving low-severity alerts',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    ColorScheme colorScheme,
    String title,
    String value,
    String description,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
