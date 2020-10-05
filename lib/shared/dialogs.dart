import 'package:flutter/material.dart';

Future<bool> DialogBox(context, heading, text) async {
  bool delete;
  await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2d3447),
          title: Text(
            heading,
            style: TextStyle(color: Colors.grey),
          ),
          content: Text(text, style: TextStyle(color: Colors.grey)),
          actions: [
            FlatButton(
                onPressed: () {
                  delete = false;
                  Navigator.pop(context);
                },
                child: Text('No')),
            FlatButton(
                onPressed: () async {
                  delete = true;
                  Navigator.pop(context);
                },
                child: Text('Yes')),
          ],
        );
      });
  return delete;
}
