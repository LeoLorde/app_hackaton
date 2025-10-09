class Issue {
  final String type;
  final String description;
  final double latitude;
  final double longitude;
  final String? imagePath;

  Issue({
    required this.type,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.imagePath,
  });

  Map<String, dynamic> toMap() => {
    'type': type,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'imagePath': imagePath,
  };

  factory Issue.fromMap(Map map) {
    return Issue(
      type: map['type'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      imagePath: map['imagePath'],
    );
  }
}