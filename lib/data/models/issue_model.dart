class Issue {
  final int? id;
  final String type;
  final String description;
  final double latitude;
  final double longitude;
  final String? imagePath;
  final String status; // 'pending', 'in_progress', 'under_analysis', 'resolved'
  final int? userId;
  final bool isAnonymous;
  final DateTime createdAt;

  Issue({
    this.id,
    required this.type,
    required this.description,
    required this.latitude,
    required this.longitude,
    this.imagePath,
    this.status = 'pending',
    this.userId,
    this.isAnonymous = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id,
    'type': type,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'imagePath': imagePath,
    'status': status,
    'user_id': userId,
    'is_anonymous': isAnonymous ? 1 : 0,
    'created_at': createdAt.toIso8601String(),
  };

  factory Issue.fromMap(Map<String, dynamic> map) {
    return Issue(
      id: map['id'],
      type: map['type'],
      description: map['description'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      imagePath: map['imagePath'],
      status: map['status'] ?? 'pending',
      userId: map['user_id'],
      isAnonymous: map['is_anonymous'] == 1,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Issue copyWith({
    int? id,
    String? type,
    String? description,
    double? latitude,
    double? longitude,
    String? imagePath,
    String? status,
    int? userId,
    bool? isAnonymous,
    DateTime? createdAt,
  }) {
    return Issue(
      id: id ?? this.id,
      type: type ?? this.type,
      description: description ?? this.description,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      imagePath: imagePath ?? this.imagePath,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
