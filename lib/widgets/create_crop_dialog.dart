import 'package:flutter/material.dart';
import 'package:greenhouse/services/crop_service.dart';
import 'package:greenhouse/models/crop.dart';

class CreateCropDialog extends StatefulWidget {
  @override
  _CreateCropDialogState createState() => _CreateCropDialogState();
}

class _CreateCropDialogState extends State<CreateCropDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cropService = CropService();
  String _name = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Create New Crop'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          decoration: InputDecoration(labelText: 'Name'),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a name';
            }
            return null;
          },
          onSaved: (value) {
            _name = value!;
          },
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Crop newCrop = await _cropService.createCrop(_name);
              Navigator.of(context).pop(newCrop);
            }
          },
          child: Text('Create'),
        ),
      ],
    );
  }
}