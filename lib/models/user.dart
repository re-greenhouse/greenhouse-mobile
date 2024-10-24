class User {
  final String id;
  final String username;
  final String password;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      role: json['role'],
    );
  }
}
