class City {
  City(
      {required this.id,
      required this.isDeleted,
      required this.createdAt,
      required this.name});

  int id;
  bool isDeleted;
  String createdAt;
  String name;

  factory City.fromJson(Map<String, dynamic> json) => City(
      id: json["id"],
      isDeleted: json["isDeleted"],
      createdAt: json["createdAt"],
      name: json["name"]);
}
