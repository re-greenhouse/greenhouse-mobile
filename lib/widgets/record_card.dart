import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:greenhouse/models/record.dart';
import 'package:greenhouse/screens/crops/edit_record.dart';
import 'package:greenhouse/widgets/delete_dialog.dart';

class RecordCard extends StatefulWidget {
  final Record record;

  const RecordCard({super.key, required this.record});

  @override
  State<RecordCard> createState() => _RecordCardState();
}

class _RecordCardState extends State<RecordCard> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
    return Card(
      color: Color(0xFFFFFFFF),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      margin: EdgeInsets.fromLTRB(30, 15, 30, 15),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Record ID: ${widget.record.id}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.delete, color: Color(0xFFDE4F4F)),
                    onPressed: () {
                      deleteDialog(
                        context,
                        "Are you sure you want to \ndelete record ${widget.record.id}?",
                        "Yes, Delete",
                        () => {},
                      );
                    },
                    padding: EdgeInsets.all(0.0)),
                IconButton(
                    icon: Icon(Icons.edit, color: Color(0xFF67864A)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditRecordScreen(
                              record: widget.record,
                              updateRecord: (Record record) {}),
                        ),
                      );
                    },
                    padding: EdgeInsets.all(0.0)),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Color(0xFF465B3F)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('Author: '),
                      ),
                      Text(widget.record.author,
                          style: TextStyle(color: Color(0xFF8E8E8E))),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.watch_later_outlined,
                          color: Color(0xFF465B3F)),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text('Entry Date: '),
                      ),
                      Flexible(
                        child: Text(widget.record.updatedDate,
                            style: TextStyle(color: Color(0xFF8E8E8E))),
                      ),
                    ],
                  ),
                  if (currentRoute == '/dashboard')
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/plant.svg',
                            height: 20.0, width: 12.0),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text('Current Phase: '),
                        ),
                        Text(widget.record.phase,
                            style: TextStyle(color: Color(0xFF8E8E8E))),
                      ],
                    ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_showDetails)
              ...widget.record.payload.data.map((payloadData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(payloadData.name),
                    Text(payloadData.value,
                        style: TextStyle(color: Color(0xFF8E8E8E))),
                  ],
                );
              }),
            TextButton(
              child: Text(_showDetails ? 'Hide Details' : 'Show Details',
                  style: TextStyle(color: Color(0xFF8E8E8E))),
              onPressed: () {
                setState(() {
                  _showDetails = !_showDetails;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
