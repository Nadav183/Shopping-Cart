import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/objectClasses/category_class.dart';
import 'package:organizer/bloc/category_bloc/category_bloc.dart';

import '../../style/lang.dart';
import '../objectClasses/item.dart';
import '../../style/designStyle.dart';

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
    var categoryID = widget.item.categoryID;
    List<Category> categoriesList =
        BlocProvider.of<CategoryBloc>(context).state;
    Category _chosenCategory;
    if (categoryID != null) {
      _chosenCategory = categoriesList
          .singleWhere((element) => element.id == widget.item.categoryID);
    }
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
            validator: (value) {
              if (value.isEmpty) {
                // makes sure value not empty
                return formLang['stock_val1'][lang];
              }
              if (double.tryParse(value) == null) {
                // makes sure the value is a double
                return formLang['stock_val2'][lang];
              }
              return null;
            },
            onSaved: ((value) {
              widget.item.amountInStock = double.parse(value);
            }),
          ),
          TextFormField(
            initialValue: '${widget.item.amountBase}',
            decoration: InputDecoration(labelText: formLang['base'][lang]),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value.isEmpty) {
                return formLang['base_val1'][lang];
              }
              if (double.tryParse(value) == null) {
                return formLang['base_val2'][lang];
              }
              if (double.parse(value) <= 0) {
                return formLang['base_val3'][lang];
              }
              return null;
            },
            onSaved: ((value) {
              widget.item.amountBase = double.parse(value);
            }),
          ),
          DropdownButtonFormField(
            onChanged: (value) {
              setState(() {
                _chosenCategory = value;
              });
            },
            onSaved: (value) {
              setState(() {
                _chosenCategory = value;
                if (value == null) {
                  widget.item.categoryID = null;
                  widget.item.categoryName = 'No Category';
                }
                else {
                  widget.item.categoryID = _chosenCategory.id;
                  widget.item.categoryName = _chosenCategory.name;
                }
              });
            },
            items: [
              DropdownMenuItem(
                //TODO:language
                  child: Text('No Category'),
                  value: null
              ),
              ...categoriesList.map((category) {
                return DropdownMenuItem(
                  child: Text(category.name),
                  value: category,
                );
              }),
            ],
            value: _chosenCategory,
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
                color: colors['saveButton'],
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
              OutlineButton(
                child: Text(
                  genLang['cancel'][lang],
                  style: TextStyle(
                      color: colors['cancelButton'],
                      fontWeight: FontWeight.bold),
                ),
                borderSide: BorderSide(color: colors['cancelButton']),
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
