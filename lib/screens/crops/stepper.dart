import 'package:flutter/material.dart';
import 'package:greenhouse/models/crop_phase.dart';
import 'package:greenhouse/services/crop_service.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:greenhouse/widgets/message_response.dart';
import '../../widgets/crop_card.dart';

class StepperWidget extends StatefulWidget {
  final CropCard chosenCrop;

  const StepperWidget({super.key, required this.chosenCrop});

  @override
  State<StepperWidget> createState() => _StepperWidgetState();
}

class _StepperWidgetState extends State<StepperWidget> {
  final List<CropCurrentPhase> itemsList = [
    CropCurrentPhase.formula,
    CropCurrentPhase.preparationArea,
    CropCurrentPhase.bunker,
    CropCurrentPhase.tunnel,
    CropCurrentPhase.incubation,
    CropCurrentPhase.casing,
    CropCurrentPhase.induction,
    CropCurrentPhase.harvest,
  ];

  CropCard? chosenCrop;

  @override
  void initState() {
    super.initState();
    chosenCrop = widget.chosenCrop;
  }

  void updatePhase() {
    setState(() {
      chosenCrop = chosenCrop;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> stepperChildren = [];

    for (final item in itemsList) {
      if (double.parse(item.phaseNumber) <
          double.parse(chosenCrop?.phase.phaseNumber ?? '0')) {
        stepperChildren.add(
          StepperButton(
            phase: item,
            isComplete: true,
            navigateTo: () {
              Navigator.pushNamed(context, '/records', arguments: {
                'cropId': chosenCrop?.id ?? '',
                'cropPhase': item.phaseName,
                'state': (chosenCrop?.state ?? '').toString(),
              });
            },
          ),
        );
      } else if (item == chosenCrop?.phase) {
        stepperChildren.add(
          StepperButton(
            phase: item,
            isCurrent: true,
            navigateTo: () {
              Navigator.pushNamed(context, '/records', arguments: {
                'cropId': chosenCrop?.id ?? '',
                'cropPhase': item.phaseName,
              });
            },
          ),
        );
      } else if (item != chosenCrop?.phase) {
        stepperChildren.add(
          StepperButton(
            phase: item,
            navigateTo: () {
              Navigator.pushNamed(context, '/records', arguments: {
                'cropId': chosenCrop?.id ?? '',
                'cropPhase': item.phaseName,
              });
            },
          ),
        );
      }

      if (item != itemsList.last) {
        stepperChildren.add(
          StepperDivider(),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Go Back',
          style: TextStyle(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StepperTitle(
                crop: chosenCrop!,
                context: context,
                onPhaseChanged: updatePhase,
              ),
              Column(children: [...stepperChildren]),
            ],
          ),
        ),
      ),
      bottomNavigationBar: GreenhouseBottomNavigationBar(),
    );
  }
}

class StepperTitle extends StatelessWidget {
  final CropCard crop;
  final BuildContext context;
  final CropService cropService = CropService();
  final VoidCallback onPhaseChanged;

  StepperTitle({
    required this.crop,
    required this.context,
    required this.onPhaseChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildStepperInfo(),
          SizedBox(height: 20),
          _buildStartDateInfo(),
          if (crop.phase.phaseName != "Formula" && crop.state == true)
            _buildMoveToPreviousCropPhase(context),
          if (crop.state == true) _buildMoveToNextPhase(context),
        ],
      ),
    );
  }

  Widget _buildStepperInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'STEPPER',
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4C6444)),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Crop Name: ${crop.name}',
          style: TextStyle(
            color: Color(0xFF444444),
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStartDateInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Start Date: ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: crop.startDate,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoveToPreviousCropPhase(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: OutlinedButton(
        onPressed: () {
          messageResponse(
            context,
            "Are you sure you want to\nmove to previous crop phase? \n\nAll records from ${crop.phase.phaseName} \nphase will be lost.",
            "Yes, Go Back",
            () async {
              CropCurrentPhase previousPhase = CropCurrentPhase
                  .values[CropCurrentPhase.values.indexOf(crop.phase) - 1];

              await cropService.updateCropPhase(
                crop.id,
                previousPhase.phaseName,
                true,
              );
              onPhaseChanged();

              Navigator.pushNamed(context, '/records', arguments: {
                'cropId': crop.id,
                'cropPhase': previousPhase.phaseName,
              });
            },
          );
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFFB07D50)),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          "Move to previous phase",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB07D50),
          ),
        ),
      ),
    );
  }

  Widget _buildMoveToNextPhase(BuildContext context) {
    bool isLastPhase = crop.phase == CropCurrentPhase.harvest;
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: OutlinedButton(
        onPressed: () async {
          if (isLastPhase) {
            await cropService.updateCropPhase(
              crop.id,
              crop.phase.phaseName,
              false,
            );
            Navigator.pushNamed(context, '/records', arguments: {
              'cropId': crop.id,
              'cropPhase': crop.phase.phaseName,
            });
          } else {
            CropCurrentPhase nextPhase = CropCurrentPhase
                .values[CropCurrentPhase.values.indexOf(crop.phase) + 1];

            await cropService.updateCropPhase(
              crop.id,
              nextPhase.phaseName,
              true,
            );
            onPhaseChanged();

            Navigator.pushNamed(context, '/records', arguments: {
              'cropId': crop.id,
              'cropPhase': nextPhase.phaseName,
            });
          }
        },
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: Color(0xFFB07D50)),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          isLastPhase ? "End Crop" : "Move to next phase",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB07D50),
          ),
        ),
      ),
    );
  }
}

class StepperButton extends StatelessWidget {
  final CropCurrentPhase phase;
  final bool isComplete;
  final bool isCurrent;
  final VoidCallback navigateTo;

  const StepperButton({
    super.key,
    required this.phase,
    this.isComplete = false,
    this.isCurrent = false,
    required this.navigateTo,
  });

  @override
  Widget build(BuildContext context) {
    if (isCurrent) {
      return Row(
        children: [
          ElevatedButton(
            onPressed: navigateTo,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF7DA257),
              minimumSize: Size(40, 40),
              side: BorderSide(color: Color(0xFF7DA257)),
              padding: EdgeInsets.zero,
            ),
            child: Text(
              phase.phaseNumber,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: navigateTo,
            child: Text(
              phase.phaseName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4C6444),
              ),
            ),
          ),
        ],
      );
    } else {
      if (isComplete) {
        return Row(
          children: [
            ElevatedButton(
              onPressed: navigateTo,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF7DA257),
                minimumSize: Size(40, 40),
                side: BorderSide(color: Color(0xFF7DA257)),
                padding: EdgeInsets.zero,
              ),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: navigateTo,
              child: Text(
                phase.phaseName,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        );
      } else {
        return Row(
          children: [
            OutlinedButton(
              onPressed: navigateTo,
              style: OutlinedButton.styleFrom(
                minimumSize: Size(40, 40),
                side: BorderSide(color: Colors.black),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                phase.phaseNumber,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(width: 10),
            GestureDetector(
              onTap: navigateTo,
              child: Text(
                phase.phaseName,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        );
      }
    }
  }
}

class StepperDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(left: 25),
      child: SizedBox(
        height: 40,
        child: CustomPaint(
          painter: _LinePainter(),
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
