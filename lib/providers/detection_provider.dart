import 'package:flutter/foundation.dart';
import '../models/camera_feed.dart';
import '../models/anomaly_event.dart';

class DetectionProvider with ChangeNotifier {
  List<CameraFeed> _cameraFeeds = [];
  List<AnomalyEvent> _anomalyEvents = [];
  bool _isMonitoring = false;
  int _totalAlerts = 0;
  int _resolvedAlerts = 0;

  List<CameraFeed> get cameraFeeds => _cameraFeeds;
  List<AnomalyEvent> get anomalyEvents => _anomalyEvents;
  bool get isMonitoring => _isMonitoring;
  int get totalAlerts => _totalAlerts;
  int get resolvedAlerts => _resolvedAlerts;
  int get activeAlerts => _totalAlerts - _resolvedAlerts;

  DetectionProvider() {
    _initializeData();
  }

  void _initializeData() {
    _cameraFeeds = [
      CameraFeed(
        id: '1',
        name: 'Store Entrance',
        location: 'Main Entrance',
        status: FeedStatus.active,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 2)),
      ),
      CameraFeed(
        id: '2',
        name: 'Electronics Section',
        location: 'Aisle 3',
        status: FeedStatus.active,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      CameraFeed(
        id: '3',
        name: 'Checkout Area',
        location: 'Counter 1',
        status: FeedStatus.active,
        lastActivity: DateTime.now().subtract(const Duration(minutes: 1)),
      ),
      CameraFeed(
        id: '4',
        name: 'Back Storage',
        location: 'Storage Room',
        status: FeedStatus.inactive,
        lastActivity: DateTime.now().subtract(const Duration(hours: 1)),
      ),
    ];

    _anomalyEvents = [
      AnomalyEvent(
        id: '1',
        cameraId: '2',
        type: AnomalyType.theftAttempt,
        severity: AnomalySeverity.high,
        description: 'Suspicious behavior detected near high-value items',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        isResolved: false,
        confidence: 0.89,
      ),
      AnomalyEvent(
        id: '2',
        cameraId: '1',
        type: AnomalyType.loitering,
        severity: AnomalySeverity.medium,
        description: 'Person loitering near entrance for extended period',
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        isResolved: true,
        confidence: 0.75,
      ),
      AnomalyEvent(
        id: '3',
        cameraId: '3',
        type: AnomalyType.unusualMovement,
        severity: AnomalySeverity.low,
        description: 'Rapid movement pattern detected',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isResolved: true,
        confidence: 0.68,
      ),
    ];

    _totalAlerts = _anomalyEvents.length;
    _resolvedAlerts = _anomalyEvents.where((e) => e.isResolved).length;
  }

  void toggleMonitoring() {
    _isMonitoring = !_isMonitoring;
    notifyListeners();
  }

  void resolveAlert(String eventId) {
    final event = _anomalyEvents.firstWhere((e) => e.id == eventId);
    event.isResolved = true;
    _resolvedAlerts++;
    notifyListeners();
  }

  void addAnomalyEvent(AnomalyEvent event) {
    _anomalyEvents.insert(0, event);
    _totalAlerts++;
    notifyListeners();
  }

  void clearResolvedAlerts() {
    _anomalyEvents.removeWhere((e) => e.isResolved);
    _totalAlerts = _anomalyEvents.length;
    _resolvedAlerts = 0;
    notifyListeners();
  }
}
