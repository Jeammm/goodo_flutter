class Tag {
  final String id;
  final String title;
  final String color;

  Tag({required this.id, required this.title, required this.color});

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as String,
      title: json['title'] as String,
      color: json['color'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'color': color};
  }
}
