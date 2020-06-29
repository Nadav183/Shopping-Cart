
import 'package:flutter/material.dart';
import 'package:organizer/style/designStyle.dart';

class MyAppBar extends AppBar {
  final String titleText;

  MyAppBar(this.titleText);

  Widget build(BuildContext context){

    return AppBar(
      title: Text(titleText, style: text['header'],),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
                MaterialPageRoute(builder: (context) => AddForm())
            );
          },
        ),
      ],
    );
  }
}