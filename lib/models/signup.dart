class SignUp{
  final String businessName;
  final String tin;
  final String firstName;
  final String lastName;
  final String username;
  final String password;
  final String logoUrl;

  SignUp({
    required this.businessName,
    required this.tin,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.password,
    this.logoUrl = 'https://schoolworkhelper.net/wp-content/uploads/2011/07/Winston-Smith.gif',
  });

  Map<String, dynamic> toJsonSignUp() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'password': password,
    };
  }

  Map<String, dynamic> toJsonCompany() {
    return {
      'name': businessName,
      'tin': tin,
      'logoUrl': logoUrl,
    };
  }

  Map<String, dynamic> toJsonSignIn() {
    return {
      'username': username,
      'password': password,
    };
  }
}