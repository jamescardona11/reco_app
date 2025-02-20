class AudioRecord {
  final String id;
  final String originalFilePath;
  final String? fileUrl;
  final String? downloadUrl;
  final String? downloadFilePath;
  final DateTime createdAt;

  AudioRecord({
    required this.id,
    required this.originalFilePath,
    this.fileUrl,
    this.downloadUrl,
    this.downloadFilePath,
    required this.createdAt,
  });

  String get name => originalFilePath.split('/').last;

  AudioRecord copyWith({
    String? id,
    String? filePath,
    String? fileUrl,
    String? downloadUrl,
    String? downloadFilePath,
    DateTime? createdAt,
  }) {
    return AudioRecord(
      id: id ?? this.id,
      originalFilePath: filePath ?? this.originalFilePath,
      fileUrl: fileUrl ?? this.fileUrl,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      downloadFilePath: downloadFilePath ?? this.downloadFilePath,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory AudioRecord.fromJson(Map<String, dynamic> json) {
    return AudioRecord(
      id: json['id'],
      originalFilePath: json['filePath'],
      fileUrl: json['fileUrl'],
      downloadUrl: json['downloadUrl'],
      downloadFilePath: json['downloadFilePath'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': originalFilePath,
      'fileUrl': fileUrl,
      'downloadUrl': downloadUrl,
      'downloadFilePath': downloadFilePath,
      'createdAt': createdAt,
    };
  }
}
