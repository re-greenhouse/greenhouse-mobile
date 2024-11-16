import 'package:flutter/material.dart';
import 'package:greenhouse/services/message_service.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:greenhouse/widgets/editing_text_form.dart';
import 'package:greenhouse/models/record.dart';
import 'package:greenhouse/widgets/message_response.dart';

import '../../services/user_preferences.dart';

class EditRecordScreen extends StatefulWidget {
  const EditRecordScreen({
    super.key,
    required this.record,
    required this.updateRecord,
  });

  final Record record;
  final Function(Record) updateRecord;

  @override
  State<EditRecordScreen> createState() => _EditRecordScreenState();
}

class _EditRecordScreenState extends State<EditRecordScreen> {
  late Map<String, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (var payload in widget.record.payload.data)
        payload.name: TextEditingController()
    };
  }

  bool _isFormValid() {
    return _controllers.values.any((controller) => controller.text.isNotEmpty);
  }

  Future<void> _updateRecord() async {
    final updatedPayloadData = widget.record.payload.data.map((payloadData) {
      return PayloadData(
        name: payloadData.name,
        value: _controllers[payloadData.name]!.text.isEmpty
            ? payloadData.value
            : _controllers[payloadData.name]!.text,
      );
    }).toList();

    final updatedRecord = Record(
      id: widget.record.id,
      author: widget.record.author,
      createdDate: widget.record.createdDate,
      updatedDate: widget.record.updatedDate,
      phase: widget.record.phase,
      payload: Payload(data: updatedPayloadData),
    );

    final MessageService messageService = MessageService();
    final company = await UserPreferences.getCompanyId();
    final user = await UserPreferences.getUsername();
    final cropId = widget.record.cropId;
    final phase = widget.record.phase;
    final recordId = widget.record.id;
    final message = "$user esta solicitando corregir un registro";
    Payload payload = Payload(data: updatedPayloadData);
    await messageService.sendMessage(company as String, message, 'edited', cropId, phase, recordId: recordId, payload: payload, differences: payload.getDifferences(widget.record.payload));

    widget.updateRecord(updatedRecord);
    Navigator.pop(context, updatedRecord);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Record', style: TextStyle(fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      widget.record.phase,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Record ID: ${widget.record.id}',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(45, 0, 45, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.record.payload.data.map((payloadData) {
                      return EditingTextForm(
                        hintText: payloadData.name,
                        valueController: _controllers[payloadData.name]!,
                        placeholderText: payloadData.value,
                        obscureText: false,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all<Color>(
                      Color(0xFF67864A),
                    ),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Color(0xFF4C6444),
                        ),
                      ),
                    ),
                  ),
                  onPressed: _isFormValid()
                      ? () {
                          messageResponse(
                            context,
                            "Are you sure you want to\nedit record ${widget.record.id}?",
                            "Yes, Edit",
                            _updateRecord,
                          );
                        }
                      : null,
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GreenhouseBottomNavigationBar(),
    );
  }
}
