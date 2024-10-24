import 'package:flutter/material.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:greenhouse/widgets/record_card.dart';
import 'package:greenhouse/models/record.dart';
import 'package:greenhouse/services/record_service.dart'; // Import the RecordService

class RecordsScreen extends StatefulWidget {
  final String cropId;
  final String cropPhase;
  RecordsScreen({required this.cropId, required this.cropPhase, super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  DateTime selectedDate = DateTime.now();
  String searchQuery = '';
  List<Record> records = [];
  final RecordService recordService = RecordService();

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  void loadRecords() async {
    try {
      records = await recordService.getRecordsByCropAndPhase(
          widget.cropId, widget.cropPhase);
      print("Records loaded: $records");
      setState(() {});
    } catch (e) {
      print('Failed to load records: $e');
    }
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
                  'Crop ID: ${widget.cropId}',
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
          ...records
              .where((record) =>
                  record.id.contains(searchQuery) ||
                  record.createdDate.contains(searchQuery))
              .map((record) => RecordCard(record: record)),
        ],
      ),
      bottomNavigationBar: GreenhouseBottomNavigationBar(),
    );
  }
}
