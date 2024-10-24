class SignIn{
  final String username;
  final String password;

  SignIn({
    required this.username,
    required this.password,
  });

  factory SignIn.fromJson(Map<String, dynamic> json) {
    return SignIn(
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}