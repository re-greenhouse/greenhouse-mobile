import 'dart:convert';
import 'dart:io';
import 'package:greenhouse/config.dart';
import 'package:http/http.dart' as http;

class IAService {
  final String url = "https://predict.ultralytics.com/";
  final Map<String, String> headers = {"x-api-key": Config.ultralytics};
  final Map<String, dynamic> data = {
    "model": Config.modelUrl,
    "imgsz": 640,
    "conf": 0.45,
    "iou": 0.50
  };

  Future<String> runInference(File imageFile) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..headers.addAll(headers)
        ..fields
            .addAll(data.map((key, value) => MapEntry(key, value.toString())))
        ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return processResponse(jsonResponse);
      } else {
        return 'Request failed with status: ${response.statusCode}.';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  String processResponse(Map<String, dynamic> jsonResponse) {
    int totalResults = 0;
    int class0Count = 0;
    int class1Count = 0;
    int class2Count = 0;

    for (var image in jsonResponse['images']) {
      for (var result in image['results']) {
        totalResults++;
        int resultClass = result['class'];
        if (resultClass == 0) {
          class0Count++;
        } else if (resultClass == 1) {
          class1Count++;
        } else if (resultClass == 2) {
          class2Count++;
        }
      }
    }

    double score =
        (class0Count * 0.5 + class1Count * 0 + class2Count * 1) / totalResults;

    print("Score: $score");
    if (score >= 0.7) {
      return "Excellent";
    } else if (score >= 0.5) {
      return "Good";
    } else {
      return "Bad";
    }
  }
}
