import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/events/item_event.dart';
import '../db/database.dart';
import '../assets/item.dart';

class AddForm extends StatelessWidget {

  Widget build(BuildContext context) {
    String name;
    double ppu;
    int base;
    int stock;
    return Card(child: Container(
        padding: EdgeInsets.all(15),
        child: Form(key: Key('thisForm'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: 'Item name'),
            onSaved: ((value) {name = value;}),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Price per unit'),
            keyboardType: TextInputType.number,
            onSaved: ((value) {ppu = double.parse(value);}),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'How many do you have right now?'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            onSaved: ((value) {stock = int.parse(value);}),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'How many do you usually need?'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            onSaved: ((value) {base = int.parse(value);}),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                var item = Item(
                  name: name,
                  pricePerUnit: ppu,
                  amountBase: base,
                  amountInStock: stock,
                );
                DatabaseProvider.db.insert(item);
                Navigator.pop(context);
              },
              child: Text('Submit'),
            ),
          ),
        ],
      ),
    )));
  }
}

class TestForm extends StatefulWidget {
  @override
  _TestFormState createState() => _TestFormState();
}

class _TestFormState extends State<TestForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    String name;
    double ppu;
    int base;
    int stock;
    //final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    return Card(child: Container(
        padding: EdgeInsets.all(15),
        child: Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(hintText: 'Item name'),
            onSaved: ((value) {name = value;}),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'Price per unit'),
            keyboardType: TextInputType.number,
            onSaved: ((value) {ppu = double.parse(value);}),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'How many do you have right now?'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            onSaved: ((value) {stock = int.parse(value);}),
          ),
          TextFormField(
            decoration: InputDecoration(hintText: 'How many do you usually need?'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            onSaved: ((value) {base = int.parse(value);}),
          ),
          RaisedButton(
            onPressed: () {
              _formKey.currentState.save();
              var item = Item(
                name: name,
                pricePerUnit: ppu,
                amountInStock: stock,
                amountBase: base,
              );
              DatabaseProvider.db.insert(item).then((item) {
                BlocProvider.of<ItemBloc>(context).add(
                    ItemEvent.insert(item)
                );
              });
              Navigator.pop(context);
            },
          ),

        ],
      ),
    )),
    );
  }
}


