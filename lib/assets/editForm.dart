import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/events/item_event.dart';

import '../db/database.dart';
import '../assets/item.dart';
import '../style/designStyle.dart';

class EditForm extends StatefulWidget {
  final Item item;
  EditForm(this.item);

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    String name;
    double ppu;
    int base;
    int stock;
    //final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    return Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.item.name,
                decoration: InputDecoration(labelText: 'Item name'),
                validator: (value) {
                  if (value.isEmpty){
                    return 'Name is required';
                  }
                  return null;
                },
                onSaved: ((value) {widget.item.name = value;}),
              ),
              TextFormField(
                initialValue: '${widget.item.pricePerUnit}',
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
                onSaved: ((value) {widget.item.pricePerUnit = double.parse(value);}),
              ),
              TextFormField(
                initialValue: '${widget.item.amountInStock}',
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
                onSaved: ((value) {widget.item.amountInStock = int.parse(value);}),
              ),
              TextFormField(
                initialValue: '${widget.item.amountBase}',
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
                onSaved: ((value) {widget.item.amountBase = int.parse(value);}),
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Text('Save', style: text['buttonText'],),
                    color: Colors.green,
                    onPressed: () {
                      if (!_formKey.currentState.validate()){
                        return;
                      }
                      _formKey.currentState.save();
                      DatabaseProvider.db.update(widget.item).then((t) {
                        BlocProvider.of<ItemBloc>(context).add(
                            ItemEvent.update(widget.item)
                        );
                      });
                      Navigator.pop(context);
                    },
                  ),
                  Spacer(),
                  MaterialButton(
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
        );
  }
}


