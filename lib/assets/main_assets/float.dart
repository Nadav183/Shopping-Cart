import 'package:flutter/material.dart';

import '../../style/designStyle.dart';
import '../../style/lang.dart';
import '../../pages/sub_pages/addForm.dart';

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
        return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                //TODO: Change the title to create
                title: Text('${genLang['edit'][lang]}'),
                content: Wrap(
                  children: <Widget>[AddForm()],
                ),
              );
            });
      },
    );
  }
}
