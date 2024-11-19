import 'package:flutter/material.dart';
import 'package:greenhouse/models/crop_phase.dart';
import 'package:greenhouse/widgets/create_crop_dialog.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:greenhouse/widgets/crop_card.dart';

import '../../services/crop_service.dart';
import '../../models/crop.dart';

class CropsInProgress extends StatefulWidget {
  const CropsInProgress({super.key});

  @override
  State<CropsInProgress> createState() => _CropsInProgressState();
}

class _CropsInProgressState extends State<CropsInProgress> {
  DateTime selectedDate = DateTime.now();
  String searchQuery = '';
  List<CropCard> cropCards = [];

  final _cropService = CropService();

  CropCurrentPhase stringToCropCurrentPhase(String phase) {
    if (phase == 'preparation_area') {
      phase = 'preparationArea';
    }
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
    final crops = await _cropService.getCropsByState(true);
    setState(() {
      cropCards = crops
          .map((crop) => CropCard(
                id: crop.id,
                startDate: parseDate(crop.createdDate),
                phase: stringToCropCurrentPhase(crop.phase),
                name: crop.name,
                state: crop.state,
                onDelete: () async {
                  setState(() {
                    cropCards.removeWhere((card) => card.id == crop.id);
                  });
                }, //its only there as a placeholder it really does nothing as it shouldn't be able to delete from the crops in progress
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
    List<String> components = date.split(',');
    components = components[0].split('/');
    String month =
        int.parse(components[0]) < 10 ? '0${components[0]}' : components[0];
    String day =
        int.parse(components[1]) < 10 ? '0${components[1]}' : components[1];
    String year = components[2];
    String reconstructedDate = '$year-$month-$day';
    DateTime parsedDate = DateTime.parse(reconstructedDate);
    return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
  }

  Future<void> removeCrop(String id) async {
    setState(() {
      cropCards.removeWhere((card) => card.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Crops in Progress',
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
            ElevatedButton(onPressed: () async {
              Crop? newCrop = await showDialog<Crop>(
                context: context,
                builder: (BuildContext context) {
                  return CreateCropDialog();
                }
              );
              if (newCrop != null) {
                setState(() {
                  cropCards.add(CropCard(
                    id: newCrop.id,
                    startDate: parseDate(newCrop.createdDate),
                    phase: stringToCropCurrentPhase(newCrop.phase),
                    name: newCrop.name,
                    state: newCrop.state,
                    onDelete: () => removeCrop(newCrop.id),
                  ));
                });
              }
            }, child: Text('Create New Crop')),
            ...cropCards.where((cropCard) =>
                cropCard.startDate.contains(searchQuery) ||
                cropCard.name.contains(searchQuery)),
          ],
        ),
        bottomNavigationBar: GreenhouseBottomNavigationBar());
  }
}