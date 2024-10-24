class Employee {
  final String username;
  final String firstName;
  final String lastName;
  final String password;
  final String invitationCode = '123456';

  Employee({
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      username: json['id'],
      firstName: json['userId'],
      lastName: json['firstName'],
      password: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'firstName': firstName,
      'lastName': lastName,
      'password': password,
      'invitationCode': invitationCode,
    };
  }
}
