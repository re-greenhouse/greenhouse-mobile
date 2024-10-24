import 'package:flutter/material.dart';

void messageResponse(BuildContext context, String message, String buttonText,
    VoidCallback onPressed) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(canvasColor: Colors.orange),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            title: Icon(
              Icons.warning_amber_sharp,
              color: Color(0xFF4C6444),
              size: 100,
            ),
            content: Text(message, textAlign: TextAlign.center),
            actions: <Widget>[
              Center(
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        onPressed();
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4C6444),
                      ),
                      child: Text(buttonText,
                          style: TextStyle(color: Colors.white)),
                    ),
                    TextButton(
                      child: const Text('Cancel',
                          style: TextStyle(color: Color(0xFF4C6444))),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      });
}
