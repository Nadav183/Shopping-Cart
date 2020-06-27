import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import '../database.dart';

class AddForm extends StatelessWidget {

  Widget build(BuildContext context) {
    return Card(child: Container(
        padding: EdgeInsets.all(15),
        child: Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: 'Item name'),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Price per unit'),
            keyboardType: TextInputType.number,
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'How many do you have right now?'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'How many do you usually need?'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(onPressed: () {Navigator.pop(context);}, child: Text('Submit'),),
          ),
        ],
      ),
    )));
  }
}