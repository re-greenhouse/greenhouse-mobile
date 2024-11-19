import 'dart:convert';
import 'package:greenhouse/config.dart';
import 'package:greenhouse/models/membership.dart';
import 'package:greenhouse/models/membership_level.dart';
import 'package:greenhouse/services/user_preferences.dart';
import 'package:http/http.dart' as http;

class MembershipService {
  final String baseUrl = Config.baseUrl;

  Future<MembershipLevel> getMembershipLevelByName(String name) async {
    final token = await UserPreferences.getToken();

    final response = await http.get(
      Uri.parse('${baseUrl}membership-levels?name={$name}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return MembershipLevel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load membership level');
    }
  }

  Future<Membership> getMembershipByCompanyId(String companyId) async {
    final token = await UserPreferences.getToken();

    final response = await http.get(
      Uri.parse('${baseUrl}memberships?profileId={$companyId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Membership.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load company');
    }
  }
}
