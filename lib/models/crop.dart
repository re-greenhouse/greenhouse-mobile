class Crop {
  final String id;
  final String createdDate;
  final String name;
  final String author;
  final bool state;
  final String phase;

  Crop({
    required this.id,
    required this.createdDate,
    required this.name,
    required this.author,
    required this.state,
    required this.phase,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'],
      createdDate: json['startDate'],
      name: json['name'],
      author: json['author'],
      state: json['state'],
      phase: json['phase'],
    );
  }
}