import 'dart:convert';
import 'package:greenhouse/config.dart';
import 'package:greenhouse/services/user_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/profile.dart';

class ProfileService {
  final String baseUrl = Config.baseUrl;
  List<Profile> profilesList = [];

  get superKeyword => null;

  Future<Profile> getUserProfile() async {
    final token = await UserPreferences.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}profiles/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Profile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<List<Profile>> getProfilesByCompany(String companyId) async {
    final token = await UserPreferences.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}profiles/companies/$companyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      return jsonResponse['profiles']
          .map<Profile>((profile) => Profile.fromJson(profile))
          .toList();
    } else {
      throw Exception('Failed to load profiles for company: $companyId');
    }
  }

  Future<Profile> addProfile(Profile profile) async {
    final response = await http.get(Uri.parse('${baseUrl}profiles'));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> existingProfiles = jsonResponse['profiles'] ?? [];
      existingProfiles.add(profile.toJson());

      final postResponse = await http.post(
        Uri.parse('${baseUrl}profiles'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'profiles': existingProfiles}),
      );

      if (postResponse.statusCode == 201) {
        profilesList.add(profile);
        return profile;
      } else {
        throw Exception('Failed to create profile');
      }
    } else {
      throw Exception('Failed to fetch existing profiles');
    }
  }

  List<Profile> getProfilesList() {
    return profilesList;
  }
}
