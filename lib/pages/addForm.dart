import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/events/item_event.dart';
import 'package:organizer/style/lang.dart';
import 'package:organizer/db/database.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/style/designStyle.dart';

class AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<AddForm> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    String name;
    double ppu;
    int base;
    int stock;
    //final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    return Card(
      child: Container(
          padding: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            autovalidate: _autovalidate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration:
                      InputDecoration(labelText: formLang['name'][lang]),
                  validator: (value) {
                    if (value.isEmpty) {
                      return formLang['name_val'][lang];
                    }
                    return null;
                  },
                  onSaved: ((value) {
                    name = value;
                  }),
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: formLang['ppu'][lang]),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty) {
                      return formLang['ppu_val1'][lang];
                    }
                    if (double.tryParse(value) == null) {
                      return formLang['ppu_val2'][lang];
                    }
                    if (double.tryParse(value) <= 0) {
                      return formLang['ppu_val3'][lang];
                    }
                    return null;
                  },
                  onSaved: ((value) {
                    ppu = double.parse(value);
                  }),
                ),
                TextFormField(
                  initialValue: '0',
                  decoration: InputDecoration(
                      labelText: formLang['stock'][lang], hintText: '0'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  validator: (value) {
                    if (value.isEmpty) {
                      return formLang['stock_val1'][lang];
                    }
                    if (!RegExp(r'^[+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$')
                        .hasMatch(value)) {
                      return formLang['stock_val2'][lang];
                    }
                    return null;
                  },
                  onSaved: ((value) {
                    stock = int.parse(value);
                  }),
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: formLang['base'][lang]),
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
                    base = int.parse(value);
                  }),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        genLang['save'][lang],
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
                        var item = Item(
                          name: name,
                          pricePerUnit: ppu,
                          amountInStock: stock,
                          amountBase: base,
                        );
                        DatabaseProvider.db.insert(item).then((item) {
                          BlocProvider.of<ItemBloc>(context)
                              .add(ItemEvent.insert(item));
                        });
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    RaisedButton(
                      child: Text(
                        genLang['cancel'][lang],
                        style: text['buttonText'],
                      ),
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
