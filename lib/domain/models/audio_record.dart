class AudioRecord {
  final String id;
  final String filePath;
  final DateTime createdAt;

  AudioRecord({
    required this.id,
    required this.filePath,
    required this.createdAt,
  });

  factory AudioRecord.fromJson(Map<String, dynamic> json) {
    return AudioRecord(
      id: json['id'],
      filePath: json['filePath'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'createdAt': createdAt,
    };
  }
}
