import 'package:flutter/material.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:greenhouse/widgets/crop_card.dart';

import '../../models/crop_phase.dart';
import '../../services/crop_service.dart';


class CropsArchive extends StatefulWidget {
  const CropsArchive({super.key});

  @override
  State<CropsArchive> createState() => _CropsArchiveState();
}

class _CropsArchiveState extends State<CropsArchive> {
  DateTime selectedDate = DateTime.now();
  String searchQuery = '';
  List<CropCard> cropCards = [];

  final _cropService = CropService();

  CropCurrentPhase stringToCropCurrentPhase(String phase) {
    String phaseCamelCase =
        phase[0].toLowerCase() + phase.substring(1).replaceAll(' ', '');
    for (CropCurrentPhase value in CropCurrentPhase.values) {
      if (value.toString().split('.').last == phaseCamelCase) {
        return value;
      }
    }
    throw Exception('Invalid phase: $phase');
  }

  initialize() async {
    final crops = await _cropService.getCropsByState(false);
    setState(() {
      cropCards = crops
          .map((crop) => CropCard(
                id: crop.id,
                startDate: parseDate(crop.createdDate),
                phase: stringToCropCurrentPhase(crop.phase),
                name: crop.name,
                state: crop.state,
                onDelete: () {
                  deleteCrop(crop.id);
                },
              ))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  String parseDate(String date) {
    // Split the string by spaces
    List<String> components = date.split(',');
    // Split the date by slashes
    components = components[0].split('/');
    String month =
    int.parse(components[0]) < 10 ? '0${components[0]}' : components[0];
    String day =
    int.parse(components[1]) < 10 ? '0${components[1]}' : components[1];
    String year = components[2];
    // Reconstruct the date string in a format that DateTime.parse can understand
    String reconstructedDate = '$year-$month-$day';
    // Parse the reconstructed string into a DateTime object
    DateTime parsedDate = DateTime.parse(reconstructedDate);

    // Format the DateTime object into a string
    return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
  }

  void deleteCrop(String cropId) {
    setState(() {
      cropCards.removeWhere((crop) => crop.id == cropId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Go Back', style: TextStyle(fontSize: 16)),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Crops Archive',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
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
                        hintText: 'Search crops...',
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
                          searchQuery =
                              '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            ...cropCards
                .where((cropCard) => cropCard.startDate.contains(searchQuery)),
          ],
        ),
        bottomNavigationBar: GreenhouseBottomNavigationBar());
  }
}
