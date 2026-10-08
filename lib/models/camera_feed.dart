enum FeedStatus {
  active,
  inactive,
  maintenance,
}

class CameraFeed {
  final String id;
  final String name;
  final String location;
  final FeedStatus status;
  final DateTime lastActivity;

  CameraFeed({
    required this.id,
    required this.name,
    required this.location,
    required this.status,
    required this.lastActivity,
  });
}
