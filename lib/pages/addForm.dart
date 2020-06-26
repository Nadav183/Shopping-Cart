import 'package:flutter/material.dart';
//import '../database.dart';

class AddForm extends StatelessWidget {

  Widget build(BuildContext context) {
    return Card(child: Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: 'Item name'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(onPressed: () {Navigator.pop(context);}, child: Text('Submit'),),
          ),
        ],
      ),
    ));
  }
}