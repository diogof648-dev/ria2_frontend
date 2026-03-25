class Widget {
  String id;
  String name;

  Widget({required this.id, required this.name});

  factory Widget.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'id': String id, 'name': String name} => Widget(id: id, name: name),
      _ => throw FormatException('Invalid JSON format for Widget'),
    };
  }
}
