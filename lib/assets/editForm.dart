import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:organizer/style/lang.dart';

import 'package:organizer/assets/item.dart';
import 'package:organizer/style/designStyle.dart';

// a form for editing an instance of an item
class EditForm extends StatefulWidget {
  final Item item;

  EditForm(this.item);

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  var _autovalidate = false; // will be set to true after first for failure

  // pop-up dialog to make sure user wants to delete an item from the list
  deleteConfirmationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
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
                  widget.item.removeFromDB(context);
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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Column(
        children: <Widget>[
          TextFormField(
            // initial value is the edited item's name
            initialValue: widget.item.name,
            decoration: InputDecoration(labelText: formLang['name'][lang]),
            validator: (value) {
              if (value.isEmpty) {
                // makes sure the value is not empty
                return formLang['name_val1'][lang];
              }
              return null;
            },
            onSaved: ((value) {
              // sets the items name to the inserted value
              widget.item.name = value;
            }),
          ),
          TextFormField(
            initialValue: '${widget.item.pricePerUnit}',
            decoration: InputDecoration(labelText: formLang['ppu'][lang]),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                // make sure the value is not empty
                return formLang['ppu_val1'][lang];
              }
              if (double.tryParse(value) == null) {
                // makes sure the value can be parsed as a double
                return formLang['ppu_val2'][lang];
              }
              if (double.tryParse(value) <= 0) {
                // makes sure the value when parsed as double is larger than 0
                return formLang['ppu_val3'][lang];
              }
              return null;
            },
            onSaved: ((value) {
              widget.item.pricePerUnit = double.parse(value);
            }),
          ),
          TextFormField(
            initialValue: '${widget.item.amountInStock}',
            decoration: InputDecoration(
                labelText: formLang['stock'][lang], hintText: '0'),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              if (value.isEmpty) {
                // makes sure value not empty
                return formLang['stock_val1'][lang];
              }
              if (!RegExp(r'^[+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$')
                  .hasMatch(value)) {
                //TODO: change this to tryParse
                // makes sure the value fits a double regexp
                return formLang['stock_val2'][lang];
              }
              return null;
            },
            onSaved: ((value) {
              widget.item.amountInStock = int.parse(value);
            }),
          ),
          TextFormField(
            initialValue: '${widget.item.amountBase}',
            decoration: InputDecoration(labelText: formLang['base'][lang]),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            validator: (value) {
              if (value.isEmpty) {
                return formLang['base_val1'][lang];
              }
              if (!RegExp(r'^[+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$')
                  .hasMatch(value)) {
                return formLang['base_val2'][lang];
              }
              if (int.parse(value) <= 0) {
                return formLang['base_val3'][lang];
              }
              return null;
            },
            onSaved: ((value) {
              widget.item.amountBase = int.parse(value);
            }),
          ),
          // adds some space before the buttons
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: Text(
                  genLang['yes'][lang],
                  style: text['buttonText'],
                ),
                color: Colors.green,
                onPressed: () {
                  if (!_formKey.currentState.validate()) {
                    if (_autovalidate == false) {
                      setState(() {
                        _autovalidate = true;
                      });
                    }
                    return;
                  }
                  _formKey.currentState.save();
                  widget.item.updateInDB(context);
                  Navigator.pop(context);
                },
              ),
              Spacer(),
              MaterialButton(
                child: Text(
                  genLang['cancel'][lang],
                  style: text['buttonText'],
                ),
                color: Colors.blue,
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          MaterialButton(
            child: RichText(
              text: TextSpan(children: [
                WidgetSpan(
                    child: Icon(
                  Icons.delete,
                  color: Colors.white,
                )),
                TextSpan(
                    text: genLang['delete'][lang], style: text['buttonText'])
              ]),
            ),
            color: Colors.red,
            onPressed: () {
              deleteConfirmationDialog(context).then((res) {
                if (res) {
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
