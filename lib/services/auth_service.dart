import 'dart:convert';
import 'package:greenhouse/config.dart';
import 'package:greenhouse/models/signup.dart';
import 'package:greenhouse/models/signin.dart';
import 'package:greenhouse/services/user_preferences.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = Config.baseUrl;

  AuthService() {
    _printProfileId();
  }

  Future<void> _printProfileId() async {
    String? profileId = await UserPreferences.getProfileId();
    print('Profile ID: $profileId');
  }

  Future<String> signUp(SignUp signUp) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/sign-up'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(signUp.toJsonSignUp()),
    );
    if (response.statusCode == 201) {
      SignIn signIn =
          SignIn(username: signUp.username, password: signUp.password);
      return await signInCompany(signIn, signUp);
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  Future<String> signIn(SignIn signIn) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(signIn.toJson()),
    );
    if (response.statusCode == 200) {
      // Extract token and profile id from response body
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String token = responseBody['token'];
      String profileId = responseBody['profile']['id'].toString();

      // Save token and profile id
      await UserPreferences.saveToken(token);
      await UserPreferences.saveProfileId(profileId);
      await UserPreferences.saveUsername(signIn.username);

      return profileId;
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<String> signInCompany(SignIn signIn, SignUp s) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/sign-in'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(signIn.toJson()),
    );
    if (response.statusCode == 200) {
      // Extract token from response headers
      Map<String, dynamic> responseBody = jsonDecode(response.body);
      String token = responseBody['token'];
      String profileId = responseBody['profile']['id'].toString();
      // Save token and profile id
      await UserPreferences.saveToken(token);
      await UserPreferences.saveProfileId(profileId);
      await UserPreferences.saveUsername(signIn.username);

      return await createCompany(s, token);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  Future<String> createCompany(SignUp signUp, String token) async {
    final response = await http.post(
      Uri.parse('${baseUrl}companies'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Use token for authentication
      },
      body: jsonEncode(signUp.toJsonCompany()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to create company, profileId');
    }
    return signUp.businessName;
  }
}
