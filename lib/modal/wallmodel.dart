class Wall {
  final String id;
  final String title;
  final String image;

  Wall({required this.id, required this.title, required this.image});

  Map<String, dynamic> toMap() => {'id': id, 'title': title, 'imageurl': image};

  factory Wall.fromMap(Map<String, dynamic> map) =>
      Wall(id: map['id'], title: map['title'], image: map['image']);
}
