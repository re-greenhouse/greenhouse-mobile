class Company {
  final String id;
  final String name;
  final String tin;
  final String logoUrl;

  Company({
    required this.id,
    required this.name,
    required this.tin,
    required this.logoUrl,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      name: json['name'],
      tin: json['tin'],
      logoUrl: json['logoUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'tin': tin, 'logoUrl': logoUrl};
  }
}
