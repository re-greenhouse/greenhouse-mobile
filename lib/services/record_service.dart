import 'dart:convert';
import 'package:greenhouse/config.dart';
import 'package:greenhouse/services/user_preferences.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/record.dart';

class RecordService {
  final String baseUrl = Config.baseUrl;

  Future<List<Record>> getRecords() async {
    final token = await UserPreferences.getToken();
    final response = await http.get(
      Uri.parse('${baseUrl}records'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> recordsList = body['records'];
      String todayStr = DateFormat('M/d/yyyy')
          .format(DateTime.now().toUtc().add(Duration(hours: -5)));

      List<Record> filteredRecords = recordsList.map((dynamic item) {
        Record record = Record.fromJson(item);
        DateTime updatedDate =
            DateFormat('M/d/yyyy, h:mm a').parseUtc(record.updatedDate);
        updatedDate = updatedDate.add(Duration(hours: -5));
        record.updatedDate = DateFormat('M/d/yyyy, h:mm a').format(updatedDate);
        return record;
      }).where((record) {
        String recordDateStr = DateFormat('M/d/yyyy')
            .format(DateFormat('M/d/yyyy, h:mm a').parse(record.updatedDate));
        return recordDateStr == todayStr;
      }).toList();

      return filteredRecords;
    } else {
      throw Exception('Failed to load records');
    }
  }

  Future<List<Record>> getRecordsByCropAndPhase(
      String cropId, String phase) async {
    final token = await UserPreferences.getToken();
    if(phase == 'Preparation Area'){
      phase = 'preparation_area';
    }
    final response = await http.get(
      Uri.parse('${baseUrl}records/$cropId/${phase.toLowerCase()}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> body = json.decode(response.body);
      List<dynamic> recordsList = body['records'];
      List<Record> convertedRecords = recordsList.map((dynamic item) {
        Record record = Record.fromJson(item);
        DateTime updatedDate =
            DateFormat('M/d/yyyy, h:mm a').parseUtc(record.updatedDate);
        updatedDate = updatedDate.add(Duration(hours: -5));
        record.updatedDate = DateFormat('M/d/yyyy, h:mm a').format(updatedDate);
        print(record);
        return record;
      }).toList();
      return convertedRecords;
    } else {
      throw Exception('Failed to load records');
    }
  }

  Future<Record> createRecord(String phase, String cropId, Payload payload) async {
  final token = await UserPreferences.getToken();
  final author = await UserPreferences.getUsername();
  if (author == null) throw Exception('Failed to get author');
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
  final record = Record(author: author, phase: phase, payload: payload, cropId: cropId);
  final response = await http.post(
    Uri.parse('${baseUrl}records'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(record.toJson()),
  );

  if (response.statusCode != 201) {
    throw Exception('Failed to create record');
  }


  Map<String, dynamic> bodyResponse = json.decode(response.body);

  DateTime createdFormattedDate =
  DateFormat('M/d/yyyy, h:mm a').parseUtc(bodyResponse['createdDate']);
  createdFormattedDate = createdFormattedDate.add(Duration(hours: -5));
  DateTime updatedFormattedDate =
  DateFormat('M/d/yyyy, h:mm a').parseUtc(bodyResponse['updatedDate']);
  updatedFormattedDate = updatedFormattedDate.add(Duration(hours: -5));

  Record newRecord = Record(
    id: bodyResponse['id'],
    createdDate:  DateFormat('M/d/yyyy, h:mm a').format(createdFormattedDate),
    updatedDate: DateFormat('M/d/yyyy, h:mm a').format(updatedFormattedDate),
    author: bodyResponse['author'],
    phase: bodyResponse['phase'],
    payload: Payload.fromJson(json.decode(bodyResponse['payload'])),
  );
  return newRecord;
}
}
