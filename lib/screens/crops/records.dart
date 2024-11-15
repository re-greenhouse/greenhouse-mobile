import 'package:flutter/material.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:greenhouse/widgets/record_card.dart';
import 'package:greenhouse/models/record.dart';
import 'package:greenhouse/services/record_service.dart';
import 'package:greenhouse/widgets/add_record_dialog.dart';

import '../../services/crop_service.dart';

class RecordsScreen extends StatefulWidget {
  final String cropId;
  final String cropPhase;
  final String cropName;
  RecordsScreen({required this.cropId, required this.cropPhase, required this.cropName, super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  DateTime selectedDate = DateTime.now();
  String searchQuery = '';
  List<Record> records = [];
  final RecordService recordService = RecordService();
  final CropService cropService = CropService();
  bool state = false;

  void removeRecord(String recordId) {
    setState(() {
      records.removeWhere((record) => record.id == recordId);
    });
  }

  @override
  void initState() {
    getCropState();
    super.initState();
    loadRecords();
  }

  Future<void> getCropState() async {
    var crop = await cropService.getCropById(widget.cropId);
    state = crop.state;
    setState(() {});
  }

  void loadRecords() async {
    try {
      records = await recordService.getRecordsByCropAndPhase(
          widget.cropId, widget.cropPhase);
      setState(() {});
    } catch (e) {
      print('Failed to load records: $e');
    }
  }

  void showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddRecordDialog(
          cropPhase: widget.cropPhase,
          cropId: widget.cropId,
          onRecordAdded: (Record newRecord) {
            setState(() {
              records.add(newRecord);
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Go Back', style: TextStyle(fontSize: 16)),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  'Crop Name: ${widget.cropName}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4C6444)),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.cropPhase,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search records...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    final DateTime? datetime = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2050),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData(
                            colorScheme: ThemeData().colorScheme.copyWith(
                                  primary: Color(0xFF465B3F),
                                ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (datetime != null) {
                      setState(() {
                        selectedDate = datetime;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          if (state)
            ElevatedButton(
                onPressed: showAddRecordDialog, child: Text('Add Record')),
          ...records
              .where((record) =>
                  record.id.contains(searchQuery) ||
                  record.createdDate.contains(searchQuery))
              .map((record) => RecordCard(
              record: record,
              onDelete: () => removeRecord(record.id))),
        ],
      ),
      bottomNavigationBar: GreenhouseBottomNavigationBar(),
    );
  }
}
