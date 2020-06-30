import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/events/item_event.dart';

import '../db/database.dart';
import '../assets/item.dart';
import '../style/designStyle.dart';

class AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Item name'),
            validator: (value) {
              if (value.isEmpty){
                return 'Name is required';
              }
              return null;
            },
            onSaved: ((value) {name = value;}),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Price per unit'),
            keyboardType: TextInputType.number,
            validator: (value){
              if (value.isEmpty){
                return'Price is required';
              }
              if (double.tryParse(value) == null){
                return'Please enter a valid number';
              }
              if (double.tryParse(value)<= 0){
                return'Wishful thinking is nice but price must be larger than zero';
              }
              return null;
            },
            onSaved: ((value) {ppu = double.parse(value);}),
          ),
          TextFormField(
            initialValue: '0',
            decoration: InputDecoration(labelText: 'How many do you have right now?', hintText: '0'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            validator: (value){
              if (value.isEmpty){
                return'This field cannot be empty, for zero insert 0';
              }
              if (!RegExp(r'^[+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$').hasMatch(value)){
                return'Please enter a positive whole number';
              }
              return null;
            },
            onSaved: ((value) {stock = int.parse(value);}),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'How many do you usually need?'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
            validator: (value){
              if (value.isEmpty){
                return 'Base amount is required';
              }
              if (!RegExp(r'^[+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$').hasMatch(value)){
                return'Please enter a positive whole number';
              }
              if (int.parse(value)<=0){
                return'Base amount cannot be zero';
              }
              return null;
            },
            onSaved: ((value) {base = int.parse(value);}),
          ),
          SizedBox(height: 50,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                child: Text('Save', style: text['buttonText'],),
                color: Colors.green,
                onPressed: () {
                  if (!_formKey.currentState.validate()){
                    return;
                  }
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
              SizedBox(width: 100,),
              RaisedButton(
                child: Text('Cancel', style: text['buttonText'],),
                color: Colors.red,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),


        ],
      ),
    )),
    );
  }
}


