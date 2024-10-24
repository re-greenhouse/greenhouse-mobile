import 'package:flutter/material.dart';
import 'package:greenhouse/models/record.dart';
import 'package:greenhouse/services/record_service.dart';

import '../services/user_preferences.dart';

class AddRecordDialog extends StatefulWidget {
  final String cropPhase;
  final String cropId;
  final Function(Record) onRecordAdded;

  AddRecordDialog({required this.cropPhase, required this.onRecordAdded, required this.cropId});

  @override
  _AddRecordDialogState createState() => _AddRecordDialogState();
}

class _AddRecordDialogState extends State<AddRecordDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final RecordService _recordService = RecordService();

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    List<String> fields = _getFieldsForPhase(widget.cropPhase);
    for (String field in fields) {
      _controllers[field] = TextEditingController();
    }
  }

  List<String> _getFieldsForPhase(String phase) {
    switch (phase) {
      case 'Formula':
        return ["Hay", "Corn", "Guano", "Cotton Seed Cake", "Soybean Meal", "Gypsum", "Urea", "Ammonium Sulfate"];
      case 'Preparation Area':
        return ["Activities", "Temperature", "Comment"];
      case 'Bunker':
        return ["T1", "T2", "T3", "Frequency", "Comment"];
      case 'Tunnel':
        return ["T1", "T2", "T3", "Frequency", "RT", "Fresh Air", "Recirculation", "Comment"];
      case 'Incubation':
        return ["Grow Room", "Air Temperature", "Compost Temperature", "Carbon Dioxide", "Air Humidity", "Setting", "Comment"];
      case 'Casing':
        return ["Grow Room", "Air Temperature", "Compost Temperature", "Carbon Dioxide", "Air Humidity", "Setting", "Comment"];
      case 'Induction':
        return ["Grow Room", "Air Temperature", "Compost Temperature", "Carbon Dioxide", "Air Humidity", "Setting", "Comment"];
      case 'Harvest':
        return ["Grow Room", "Air Temperature", "Compost Temperature", "Carbon Dioxide", "Air Humidity", "Setting", "Comment"];
      default:
        return [];
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void _createRecord() async {
    if (_formKey.currentState!.validate()) {
      List<PayloadData> payloadData = _controllers.entries.map((entry) {
        return PayloadData(name: entry.key, value: entry.value.text);
      }).toList();

      Payload payload = Payload(data: payloadData);

      Record newRecord = await _recordService.createRecord(widget.cropPhase, widget.cropId, payload); // Replace with actual cropId
      widget.onRecordAdded(newRecord);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Record'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: _controllers.keys.map((field) {
              return TextFormField(
                controller: _controllers[field],
                decoration: InputDecoration(labelText: field),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter $field';
                  }
                  return null;
                },
              );
            }).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createRecord,
          child: Text('Create'),
        ),
      ],
    );
  }
}