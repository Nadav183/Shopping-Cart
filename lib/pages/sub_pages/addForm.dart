import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/objectClasses/category_class.dart';
import 'package:organizer/bloc/category_bloc/category_bloc.dart';

import '../../style/lang.dart';
import '../../assets/objectClasses/item.dart';
import '../../style/designStyle.dart';

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
    double base;
    double stock;
    int categoryID;
    String categoryName;
    List<Category> categoriesList =
        BlocProvider.of<CategoryBloc>(context).state;
    Category _chosenCategory;
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
            validator: (value) {
              if (value.isEmpty) {
                return formLang['stock_val1'][lang];
              }
              if (double.tryParse(value) == null) {
                return formLang['stock_val2'][lang];
              }
              return null;
            },
            onSaved: ((value) {
              stock = double.parse(value);
            }),
          ),
          TextFormField(
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
              base = double.parse(value);
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
                print(_chosenCategory);
                _chosenCategory = value;
                if (value == null) {
                  categoryID = null;
                  categoryName = 'No Category';
                } else {
                  categoryID = _chosenCategory.id;
                  categoryName = _chosenCategory.name;
                }
              });
            },
            items: [
              DropdownMenuItem(
                  child: Text(shopLang['no_category'][lang]), value: null),
              ...categoriesList.map((category) {
                return DropdownMenuItem(
                  child: Text(category.name),
                  value: category,
                );
              }),
            ],
            value: _chosenCategory,
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
                  var item = Item(
                    name: name,
                    pricePerUnit: ppu,
                    amountInStock: stock,
                    amountBase: base,
                    categoryID: categoryID,
                    categoryName: categoryName,
                  );
                  item.insertToDB(context);
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
