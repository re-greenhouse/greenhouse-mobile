import 'dart:convert';
import 'package:greenhouse/config.dart';
import 'package:greenhouse/models/signin.dart';
import 'package:greenhouse/services/user_preferences.dart';
import 'package:http/http.dart' as http;

import 'company_service.dart';

class AuthService {
  final String baseUrl = Config.baseUrl;

  AuthService() {
    _printProfileId();
  }

  Future<void> _printProfileId() async {
    String? profileId = await UserPreferences.getProfileId();
    print('Profile ID: $profileId');
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

      //call the company service to add the company id to the user preferences
      await CompanyService().getCompanyByProfileIdUserPreferences();
      return profileId;
    } else {
      throw Exception('Failed to sign in');
    }
  }
}
