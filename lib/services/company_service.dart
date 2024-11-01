import 'dart:convert';
import 'package:greenhouse/config.dart';
import 'package:greenhouse/models/company.dart';
import 'package:greenhouse/models/employee.dart';
import 'package:greenhouse/services/user_preferences.dart';
import 'package:http/http.dart' as http;

class CompanyService {
  final String baseUrl = Config.baseUrl;

  Future<Company> getCompanyByProfileId() async {
    final token = await UserPreferences.getToken();
    final profileId = await UserPreferences.getProfileId();

    final response = await http.get(
      Uri.parse('${baseUrl}companies?profileId={$profileId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Company.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<Company> getCompanyByProfileIdUserPreferences() async {
    final token = await UserPreferences.getToken();
    final profileId = await UserPreferences.getProfileId();

    final response = await http.get(
      Uri.parse('${baseUrl}companies?profileId={$profileId}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final company = Company.fromJson(json.decode(response.body));
      await UserPreferences.saveCompanyId(company.id);
      return company;
    } else {
      throw Exception('Failed to load profile');
    }
  }

  Future<String> addEmployeeToCompany(String employeeProfileId) async {
    final token = await UserPreferences.getToken();
    final response = await http.post(
      Uri.parse('${baseUrl}companies/employees'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'employeeProfileId': employeeProfileId,
      }),
    );
    if (response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Failed to add employee to company: ${response.body}');
    }
  }

  Future<String> createEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse('${baseUrl}auth/sign-up'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(employee.toJson()),
    );
    if (response.statusCode == 201) {
      final responseBody = json.decode(response.body);
      final String profileId = responseBody['profile']['id'];
      return await addEmployeeToCompany(profileId);
    } else {
      throw Exception('Failed to create employee: ${response.body}');
    }
  }

  Future<String> updateCompany(Company company) async {
    final token = await UserPreferences.getToken();
    final response = await http.patch(
      Uri.parse('${baseUrl}companies/${company.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(company.toJson()),
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to update company: ${response.body}');
    }
  }
}
