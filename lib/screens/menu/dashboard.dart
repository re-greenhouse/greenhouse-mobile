import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenhouse/services/record_service.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:greenhouse/widgets/record_card.dart';
import 'package:greenhouse/models/record.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<Record> records = [];
  final RecordService recordService = RecordService();

  @override
  void initState() {
    super.initState();
    loadRecords();
  }

  Future<void> loadRecords() async {
    try {
      records = await recordService.getRecords();
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
        title: Row(children: [
          SvgPicture.asset(
            'assets/logo/logo.svg',
            width: 30,
            height: 30,
          ),
          SizedBox(width: 5),
          Text('Greenhouse',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ]),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Welcome,',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16.0),
              Text('Dashboard',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  DashboardButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/crops-in-progress');
                    },
                    svgAsset: 'assets/icons/clock.svg',
                    buttonText: 'Crops in\nProgress',
                  ),
                  DashboardButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/crops-archive');
                    },
                    svgAsset: 'assets/icons/archive.svg',
                    buttonText: 'Crops\nArchive',
                  ),
                  DashboardButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/crops-graphics');
                    },
                    svgAsset: 'assets/icons/statistics.svg',
                    buttonText: 'Statistical\nReports',
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                'Recent records',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              ...records.map((record) => RecordCard(record: record)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GreenhouseBottomNavigationBar(),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String svgAsset;
  final String buttonText;

  DashboardButton({
    required this.onPressed,
    required this.svgAsset,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF67864A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            fixedSize: Size(100, 100),
          ),
          child: SvgPicture.asset(svgAsset),
        ),
        Text(
          buttonText,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
