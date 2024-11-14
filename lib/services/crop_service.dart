import 'dart:convert';
import 'package:greenhouse/config.dart';
import 'package:greenhouse/services/user_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/crop.dart';
import 'message_service.dart';

class CropService {
  final String baseUrl = Config.baseUrl;

  Future<Crop> getCropById(String id) async {
    final token = await UserPreferences.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}crops/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      return Crop.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load crop');
    }
  }

  Future<List> getCrops() async {
    final response = await http.get(
      Uri.parse('${baseUrl}crops'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${UserPreferences.getToken()}',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load crops');
    }
  }

  Future<List<Crop>> getCropsByState(bool state) async {
    final token = await UserPreferences.getToken();
    final companyId = await UserPreferences.getCompanyId();
    final response = await http.get(
      Uri.parse('${baseUrl}crops/company/$companyId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic>? crops = body['crops'];
      if (crops != null) {
        List<Crop> cropObjects =
            crops.map((dynamic item) => Crop.fromJson(item)).toList();
        List<Crop> filteredCrops =
            cropObjects.where((Crop crop) => crop.state == state).toList();
        return filteredCrops;
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load crops');
    }
  }

  Future<Crop> createCrop(String name) async {
    final token = await UserPreferences.getToken();
    final user = await UserPreferences.getUsername();
    MessageService messageService = MessageService();
    final company = await UserPreferences.getCompanyId();
    final String message = "Cultivo $name creado por $user";
    final author = await UserPreferences.getUsername();
    final companyId = await UserPreferences.getCompanyId();
    final response = await http.post(
      Uri.parse('${baseUrl}crops'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'author': author,
        'companyId': companyId,
      }),
    );

    if (response.statusCode == 201) {
      messageService.sendMessage(company!, message);
      return Crop.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create crop');
    }
  }

  Future<void> updateCropPhase(String cropId, String phase, bool state) async {
    final token = await UserPreferences.getToken();
    if (phase == 'Formula') {
      phase = 'formula';
    } else if (phase == 'Preparation Area') {
      phase = 'preparation_area';
    } else if (phase == 'Bunker') {
      phase = 'bunker';
    } else if (phase == 'Tunnel') {
      phase = 'tunnel';
    } else if (phase == 'Incubation') {
      phase = 'incubation';
    } else if (phase == 'Casing') {
      phase = 'casing';
    } else if (phase == 'Induction') {
      phase = 'induction';
    } else if (phase == 'Harvest') {
      phase = 'harvest';
    }
    final response = await http.patch(
      Uri.parse('${baseUrl}crops/$cropId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'phase': phase,
        'state': state,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update crop phase');
    }
  }

  Future<void> updateImageAndQuality(String cropId, String quality, String imageUrl, String cropName) async {
    final token = await UserPreferences.getToken();
    // Create an instance of MessageService
    MessageService messageService = MessageService();
    final company = await UserPreferences.getCompanyId();
    final String message = "Cultivo $cropName - terminado con calidad $quality";
    final response = await http.patch(
      Uri.parse('${baseUrl}crops/image/$cropId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'imageUrl': imageUrl,
        'quality': quality,
      }),
    );


    if (response.statusCode == 200) {
      // Send the message
      messageService.sendMessage(company!, message);
    } else {
      throw Exception('Failed to update image quality');
    }
  }
}
