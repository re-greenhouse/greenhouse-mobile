import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenhouse/models/crop.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';

import '../../models/crop_phase.dart';
import '../../services/crop_service.dart';

class CropsGraphics extends StatefulWidget {
  const CropsGraphics({super.key});

  @override
  State<CropsGraphics> createState() => _CropsGraphicsState();
}

class _CropsGraphicsState extends State<CropsGraphics> {
  DateTime selectedDate = DateTime.now();
  String searchQuery = '';
  List<CropCardGraphics> cropCards = [];

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
          .map((crop) => CropCardGraphics(
              crop: crop, startDate: parseDate(crop.createdDate)))
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
                'Harvested Crop Statistics',
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
            ...cropCards.where(
                (cropCard) => cropCard.crop.createdDate.contains(searchQuery)),
          ],
        ),
        bottomNavigationBar: GreenhouseBottomNavigationBar());
  }
}

class CropCardGraphics extends StatefulWidget {
  final Crop crop;
  final String startDate;

  const CropCardGraphics(
      {super.key, required this.crop, required this.startDate});

  @override
  State<CropCardGraphics> createState() => _CropCardGraphicsState();
}

class _CropCardGraphicsState extends State<CropCardGraphics> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {},
              child: Card(
                color: Color(0xFFFFFFFF),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
                child: Column(
                  children: [
                    Image.asset('assets/mushroom_images/mushroom.jpeg'),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Crop Name: ${widget.crop.name}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/statics',
                                        arguments: widget.crop);
                                  },
                                  child: Row(
                                    children: [
                                      Text('View Statics',
                                          style: TextStyle(
                                              color: Color(0xFF67864A))),
                                      Icon(Icons.bar_chart,
                                          color: Color(0xFF67864A)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.watch_later_outlined,
                                        color: Color(0xFF465B3F)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text('Start Date: '),
                                    ),
                                    Text(widget.startDate), //parseDate
                                  ],
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/plant.svg',
                                        height: 20.0, width: 12.0),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text('Current Phase: '),
                                    ),
                                    Text(widget.crop.phase),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
