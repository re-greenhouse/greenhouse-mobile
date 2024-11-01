import 'dart:io';
import 'package:flutter/material.dart';
import 'package:greenhouse/models/crop_phase.dart';
import 'package:greenhouse/screens/camera/camera_screen.dart';
import 'package:greenhouse/screens/camera/image_view_screen.dart';
import 'package:greenhouse/services/crop_service.dart';
import 'package:greenhouse/widgets/bottom_navigation_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

class StepperTitle extends StatefulWidget {
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
  _StepperTitleState createState() => _StepperTitleState();
}

class _StepperTitleState extends State<StepperTitle> {
  List<XFile?> images = [];
  final imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePaths =
        prefs.getStringList('saved_image_paths_${widget.crop.id}') ?? [];
    setState(() {
      images = imagePaths.map((path) => XFile(path)).toList();
    });
  }

  Future<void> _saveImages() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePaths = images.map((image) => image!.path).toList();
    await prefs.setStringList(
        'saved_image_paths_${widget.crop.id}', imagePaths);
  }

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
          if (widget.crop.phase.phaseName == CropCurrentPhase.harvest.phaseName)
            Column(
              children: [
                if (widget.crop.state) ...[
                  _uploadPictureButton(context),
                  if (images.isNotEmpty) _buildImageView(),
                ] else
                  _buildImageView(),
              ],
            ),
          if (widget.crop.phase.phaseName != CropCurrentPhase.harvest.phaseName)
            _buildMoveToNextPhase(context),
          if (widget.crop.phase.phaseName !=
                  CropCurrentPhase.formula.phaseName &&
              widget.crop.state == true)
            _buildMoveToPreviousCropPhase(context),
        ],
      ),
    );
  }

  Widget _uploadPictureButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: OutlinedButton(
        onPressed: () async {
          if (images.isEmpty) {
            await _optionsDialogBox(context);
          } else {
            await widget.cropService.updateCropPhase(
              widget.crop.id,
              widget.crop.phase.phaseName,
              false,
            );
            Navigator.pushNamed(context, '/records', arguments: {
              'cropId': widget.crop.id,
              'cropPhase': widget.crop.phase.phaseName,
            });
          }
        },
        child: Text(
          images.isEmpty
              ? "Upload a picture of the resulting crop"
              : "End Crop",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB07D50),
          ),
        ),
      ),
    );
  }

  Widget _buildImageView() {
    return ListView.builder(
      padding: const EdgeInsets.all(10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: images.length,
      itemBuilder: (BuildContext context, int index) {
        File imageFile = File(images[index]!.path);
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Stack(
            children: [
              InkWell(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 200,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ImageViewScreen(
                      imageFile: imageFile,
                    ),
                  ));
                },
              ),
              if (widget.crop.state)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () async {
                      setState(() {
                        images.removeAt(index);
                      });
                      await _saveImages();
                      widget.onPhaseChanged();
                    },
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _optionsDialogBox(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () async {
                    XFile? picture = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picture != null) {
                      Navigator.pop(context);
                      setState(() {
                        images.add(picture);
                      });
                      await _saveImages();
                      widget.onPhaseChanged();
                    }
                  },
                  child: Row(
                    children: [
                      Icon(Icons.photo_library, color: Color(0xFF7DA257)),
                      SizedBox(width: 8),
                      Text('Upload a picture from gallery'),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: Row(
                    children: [
                      Icon(Icons.camera_alt, color: Color(0xFF7DA257)),
                      SizedBox(width: 8),
                      Text('Take a picture'),
                    ],
                  ),
                  onTap: () async {
                    String picturePath = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CameraScreen(),
                      ),
                    );
                    Navigator.pop(context);
                    setState(() {
                      images.add(XFile(picturePath));
                    });
                    await _saveImages();
                    widget.onPhaseChanged();
                  },
                ),
              ],
            ),
          ),
        );
      },
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
          'Crop Name: ${widget.crop.name}',
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
              text: widget.crop.startDate,
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
        onPressed: () async {
          CropCurrentPhase previousPhase = CropCurrentPhase
              .values[CropCurrentPhase.values.indexOf(widget.crop.phase) - 1];

          await widget.cropService.updateCropPhase(
            widget.crop.id,
            previousPhase.phaseName,
            true,
          );
          widget.onPhaseChanged();
          Navigator.pushNamed(context, '/records', arguments: {
            'cropId': widget.crop.id,
            'cropPhase': previousPhase.phaseName,
          });
        },
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
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: OutlinedButton(
        onPressed: () async {
          CropCurrentPhase nextPhase = CropCurrentPhase
              .values[CropCurrentPhase.values.indexOf(widget.crop.phase) + 1];

          await widget.cropService.updateCropPhase(
            widget.crop.id,
            nextPhase.phaseName,
            true,
          );
          widget.onPhaseChanged();
          Navigator.pushNamed(context, '/records', arguments: {
            'cropId': widget.crop.id,
            'cropPhase': nextPhase.phaseName,
          });
        },
        child: Text(
          "Move to next phase",
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
