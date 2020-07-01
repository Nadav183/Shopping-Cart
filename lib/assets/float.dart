import 'package:flutter/material.dart';
import 'package:organizer/style/designStyle.dart';
import 'package:organizer/style/lang.dart';
import '../pages/addForm.dart';

class MyFloatingButton extends FloatingActionButton {
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Row(
        children: <Widget>[
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          SizedBox(width: 5),
          Text(
            fltLang['add'][lang],
            style: text['buttonText'],
          )
        ],
      ),
      tooltip: fltLang['add_tltp'][lang],
      backgroundColor: Colors.green,
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AddForm()));
      },
    );
  }
}
