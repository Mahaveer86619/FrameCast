class VideoMetadata {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final String videoUrl;
  final String thumbnailUrl;
  final String ownerId;
  final String? ownerPicUrl;
  final String? ownerName;

  VideoMetadata({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.ownerId,
    this.ownerPicUrl,
    this.ownerName,
  });
  
  factory VideoMetadata.fromJson(Map<String, dynamic> json) {
    return VideoMetadata(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      createdAt: DateTime.parse(json['created_at']),
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      ownerId: json['owner_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'owner_id': ownerId,
    };
  }

  VideoMetadata copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    String? videoUrl,
    String? thumbnailUrl,
    String? ownerId,
    String? ownerName,
    String? ownerPicUrl,
  }) {
    return VideoMetadata(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      videoUrl: videoUrl ?? this.videoUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerPicUrl: ownerPicUrl ?? this.ownerPicUrl,
    );
  }

  @override
  String toString() {
    return 'VideoMetadata(id: $id, title: $title, description: $description, createdAt: $createdAt, videoUrl: $videoUrl, thumbnailUrl: $thumbnailUrl, ownerId: $ownerId,)';
  }
}
