import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:organizer/style/designStyle.dart';
import '../pages/addForm.dart';
import '../db/database.dart';

class MyFloatingButton extends FloatingActionButton {
  Widget build(BuildContext context){
    return FloatingActionButton.extended(
      label: Row(
        children: <Widget>[
          Icon(Icons.add, color: Colors.white,),
          SizedBox(width: 5),
          Text('Add Item',style: text['buttonText'],)
        ],
      ),
      tooltip: 'Add new item',
      backgroundColor: Colors.green,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddForm())
        );
      },
    );
  }
}

class MyFloatingButton2 extends FloatingActionButton {

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