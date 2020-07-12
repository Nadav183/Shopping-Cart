import 'package:flutter/material.dart';
import 'package:organizer/assets/objectClasses/category_class.dart';

import '../../style/lang.dart';
import '../../style/designStyle.dart';

class CategoryForm extends StatefulWidget {
  @override
  _CategoryFormState createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  final _formKey = GlobalKey<FormState>();
  var _autovalidate = false;
  String name;
  bool _display = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: formLang['name'][lang]),
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
          SwitchListTile(
            title: Text('Display in Shopping Cart?'),
            value: _display,
            onChanged: (value) {
              setState(() {
                _display = value;
              });
            },
          ),
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
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
                  var category = Category(
                    name: name,
                    display: _display,
                  );
                  category.insertToDB(context);
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 20,
              ),
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
        ],
      ),
    );
  }
}
