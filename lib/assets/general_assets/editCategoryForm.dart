import 'package:flutter/material.dart';
import 'package:organizer/assets/objectClasses/category_class.dart';

import '../../style/lang.dart';
import '../../style/designStyle.dart';

class EditCategoryForm extends StatefulWidget {
  final Category category;

  EditCategoryForm(this.category);

  @override
  _EditCategoryFormState createState() => _EditCategoryFormState();
}

class _EditCategoryFormState extends State<EditCategoryForm> {
  deleteConfirmationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('${formLang['delete'][lang]} ${widget.category.name}'),
            content: Text(
              '${formLang['confirm1'][lang]} \'${widget.category.name}\' ${formLang['confirm2'][lang]}',
              maxLines: 5,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(genLang['yes'][lang]),
                onPressed: () {
                  widget.category.removeFromDB(context);
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
  var _autovalidate = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autovalidate,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            initialValue: widget.category.name,
            decoration: InputDecoration(labelText: formLang['name'][lang]),
            validator: (value) {
              if (value.isEmpty) {
                return formLang['name_val'][lang];
              }
              return null;
            },
            onSaved: ((value) {
              widget.category.name = value;
            }),
          ),
          SwitchListTile(
            title: Text('Display in Shopping Cart?'),
            value: widget.category.display,
            onChanged: (value) {
              setState(() {
                widget.category.display = value;
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
                  widget.category.updateInDB(context);
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
          SizedBox(height: 20),
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
          )
        ],
      ),
    );
  }
}
