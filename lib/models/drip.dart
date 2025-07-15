class Drip {
  final int id;
  final String key;
  final dynamic content;

  Drip({
    required this.id,
    required this.key,
    required this.content,
  });

  factory Drip.fromMap(Map<String, dynamic> json) {
    return Drip(
      id: json['id'],
      key: json['key'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'key': key,
      'content': content,
    };
  }
}
