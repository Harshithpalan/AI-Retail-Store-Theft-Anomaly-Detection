enum AnomalyType {
  theftAttempt,
  loitering,
  unusualMovement,
  unauthorizedAccess,
  tampering,
  other,
}

enum AnomalySeverity {
  low,
  medium,
  high,
  critical,
}

class AnomalyEvent {
  final String id;
  final String cameraId;
  final AnomalyType type;
  final AnomalySeverity severity;
  final String description;
  final DateTime timestamp;
  bool isResolved;
  final double confidence;

  AnomalyEvent({
    required this.id,
    required this.cameraId,
    required this.type,
    required this.severity,
    required this.description,
    required this.timestamp,
    required this.isResolved,
    required this.confidence,
  });
}
