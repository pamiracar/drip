class Water {
  final int id;
  final String key;
  final dynamic content;

  Water({
    required this.id,
    required this.key,
    required this.content,
  });

  factory Water.fromMap(Map<String, dynamic> json) {
    return Water(
      id : json["id"],
      key : json["key"],
      content : json["content"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id" : id,
      "key" : key,
      "content" : content,
    };
  }
}
