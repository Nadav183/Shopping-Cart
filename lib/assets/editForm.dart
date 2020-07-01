import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/events/item_event.dart';
import 'package:organizer/style/lang.dart';

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
  var _autovalidate = false;

  deleteConfirmationDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('${formLang['delete'][lang]} ${widget.item.name}'),
        content: Text(
          '${formLang['confirm1'][lang]} \'${widget.item.name}\' ${formLang['confirm2'][lang]}',
          maxLines: 5,
          softWrap: true,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(genLang['yes'][lang]),
            onPressed: () {
              DatabaseProvider.db.remove(widget.item.id);
              BlocProvider.of<ItemBloc>(context).add(
                  ItemEvent.delete(widget.item)
              );
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            child: Text(genLang['no'][lang]),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    });
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){

    return Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: widget.item.name,
                decoration: InputDecoration(labelText: formLang['name'][lang]),
                validator: (value) {
                  if (value.isEmpty){
                    return formLang['name_val1'][lang];
                  }
                  return null;
                },
                onSaved: ((value) {widget.item.name = value;}),
              ),
              TextFormField(
                initialValue: '${widget.item.pricePerUnit}',
                decoration: InputDecoration(labelText: formLang['ppu'][lang]),
                keyboardType: TextInputType.number,
                validator: (value){
                  if (value.isEmpty){
                    return formLang['ppu_val1'][lang];
                  }
                  if (double.tryParse(value) == null){
                    return formLang['ppu_val2'][lang];
                  }
                  if (double.tryParse(value)<= 0){
                    return formLang['ppu_val3'][lang];
                  }
                  return null;
                },
                onSaved: ((value) {widget.item.pricePerUnit = double.parse(value);}),
              ),
              TextFormField(
                initialValue: '${widget.item.amountInStock}',
                decoration: InputDecoration(labelText: formLang['stock'][lang], hintText: '0'),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                validator: (value){
                  if (value.isEmpty){
                    return formLang['stock_val1'][lang];
                  }
                  if (!RegExp(r'^[+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$').hasMatch(value)){
                    return formLang['stock_val2'][lang];
                  }
                  return null;
                },
                onSaved: ((value) {widget.item.amountInStock = int.parse(value);}),
              ),
              TextFormField(
                initialValue: '${widget.item.amountBase}',
                decoration: InputDecoration(labelText: formLang['base'][lang]),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
                validator: (value){
                  if (value.isEmpty){
                    return formLang['base_val1'][lang];
                  }
                  if (!RegExp(r'^[+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$').hasMatch(value)){
                    return formLang['base_val2'][lang];
                  }
                  if (int.parse(value)<=0){
                    return formLang['base_val3'][lang];
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
                    child: Text(genLang['yes'][lang], style: text['buttonText'],),
                    color: Colors.green,
                    onPressed: () {
                      if (!_formKey.currentState.validate()){
                        if (_autovalidate == false) {
                          setState(() {
                            _autovalidate = true;
                          });
                        }
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
                    child: Text(genLang['cancel'][lang], style: text['buttonText'],),
                    color: Colors.blue,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              MaterialButton(
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(child: Icon(Icons.delete, color: Colors.white,)),
                      TextSpan(text:genLang['delete'][lang], style: text['buttonText'])
                    ]
                  ),
                ),
                color: Colors.red,
                onPressed: () {
                  deleteConfirmationDialog(context).then((res) {
                    if (res){
                      Navigator.pop(context);
                    }
                  });
                },
              ),
            ],
          ),
        );
  }
}


