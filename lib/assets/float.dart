import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../pages/addForm.dart';
import '../db/database.dart';

class MyFloatingButton extends FloatingActionButton {

  @override
  Widget build(BuildContext context){
    return Builder(builder: (context) => SpeedDial(
      child: Icon(Icons.add),
      children: <SpeedDialChild>[
        SpeedDialChild(
          child: Icon(Icons.add, color: Colors.white),
          label: 'Add item',
          backgroundColor: Colors.green,
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddForm())
            );
            print('pushAddForm was called');
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.remove, color: Colors.white),
          label: 'Remove item',
          backgroundColor: Colors.red,
          onTap: () {
            DatabaseProvider.db.deleteDatabase();
            DatabaseProvider.db.getItems();
          },
        ),
      ],
    ));
  }
}