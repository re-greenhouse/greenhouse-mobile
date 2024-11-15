import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:greenhouse/models/crop_phase.dart';
import 'package:greenhouse/widgets/delete_dialog.dart';

import '../services/crop_service.dart';
import '../services/message_service.dart';
import '../services/user_preferences.dart';

class CropCard extends StatefulWidget {
  final String startDate;
  final CropCurrentPhase phase;
  final String id;
  final String name;
  final bool state;
  final VoidCallback onDelete;

  const CropCard(
      {super.key,
      required this.startDate,
      required this.phase,
      required this.id,
      required this.name,
      required this.state,
      required this.onDelete});

  @override
  State<CropCard> createState() => _CropCardState();
}

class _CropCardState extends State<CropCard> {
  final CropService cropService = CropService();
  final MessageService messageService = MessageService();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                if (widget.phase == CropCurrentPhase.harvest) {
                  Navigator.pushNamed(context, '/stepper', arguments: widget);
                } else {
                  Navigator.pushNamed(context, '/stepper', arguments: widget);
                }
              },
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
                              Flexible(
                                child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Crop Name: ${widget.name}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Text('View Logs',
                                          style: TextStyle(
                                              color: Color(0xFF67864A))),
                                      Icon(Icons.arrow_forward,
                                          color: Color(0xFF67864A)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (widget.phase == CropCurrentPhase.harvest)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    deleteDialog(
                                        context,
                                        "Are you sure you want to \ndelete crop ${widget.id}?",
                                        "Yes, Delete",
                                        () async {
                                          await cropService.deleteCrop(widget.id);
                                          final company = await UserPreferences.getCompanyId();
                                          final String message = "Cultivo ${widget.name} - eliminado por ${await UserPreferences.getUsername()}";
                                          const String action = 'deleted';
                                          final String cropId = widget.id;
                                          final String phase = widget.phase.phaseName;
                                          messageService.sendMessage(company!, message, action, cropId, phase);
                                          widget.onDelete();
                                  });
                                  },
                                  child: Row(
                                    children: [
                                      Text(
                                        'Delete',
                                        style:
                                            TextStyle(color: Color(0xFFDE4F4F)),
                                      ),
                                      Icon(Icons.delete,
                                          color: Color(0xFFDE4F4F)),
                                    ],
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
                                    Text(widget.startDate),
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
                                    Text(widget.phase.phaseName),
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
