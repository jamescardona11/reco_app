class AudioRecord {
  final String id;
  final String filePath;
  final String? fileUrl;
  final DateTime createdAt;

  AudioRecord({
    required this.id,
    required this.filePath,
    this.fileUrl,
    required this.createdAt,
  });

  String get name => filePath.split('/').last;

  AudioRecord copyWith({
    String? id,
    String? filePath,
    String? fileUrl,
    DateTime? createdAt,
  }) {
    return AudioRecord(
      id: id ?? this.id,
      filePath: filePath ?? this.filePath,
      fileUrl: fileUrl ?? this.fileUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AudioRecord.fromJson(Map<String, dynamic> json) {
    return AudioRecord(
      id: json['id'],
      filePath: json['filePath'],
      fileUrl: json['fileUrl'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'fileUrl': fileUrl,
      'createdAt': createdAt,
    };
  }
}
