class Profile {
  final String id;
  final String userId;
  final String firstName;
  final String lastName;
  final String iconUrl;
  final String role;

  Profile({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.iconUrl,
    required this.role,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      userId: json['userId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      iconUrl: json['iconUrl'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'iconUrl': iconUrl,
      'role': role,
    };
  }
}
