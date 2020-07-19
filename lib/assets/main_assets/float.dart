import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:organizer/assets/general_assets/categoryForm.dart';

import '../../style/designStyle.dart';
import '../../style/lang.dart';
import '../../pages/sub_pages/addForm.dart';

class MyFloatingButton extends FloatingActionButton {
  oldDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            //TODO: Change the title to create
            title: Text('${genLang['edit'][lang]}'),
            content: Wrap(
              children: <Widget>[AddForm()],
            ),
          );
        });
  }

  newItemDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('What would you like to add?'),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('${formLang['add'][lang]}'),
                                content: Wrap(
                                  children: <Widget>[AddForm()],
                                ),
                              );
                            }).then((_) {
                          Navigator.pop(context);
                        });
                      },
                      child: Card(
                        color: primaryColorLight,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                'Item',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 20),
                              Icon(
                                Icons.fastfood,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        TextEditingController customController =
                            TextEditingController();

                        return showDialog(
                            context: context,
                            builder: (context) {
                              customController.clear();
                              return AlertDialog(
                                title: Text(catLang['new_category'][lang]),
                                content: Wrap(
                                  children: [CategoryForm()],
                                ),
                              );
                            }).then((_) {
                          Navigator.pop(context);
                        });
                      },
                      child: Card(
                        color: secondaryColor,
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text('Category', style: TextStyle(fontSize: 18)),
                              SizedBox(height: 20),
                              Icon(
                                Icons.category,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      tooltip: fltLang['add_tltp'][lang],
      backgroundColor: primaryColor,
      onPressed: () {
        return newItemDialog(context);
      },
    );
  }
}

class MySpeedDial extends FloatingActionButton {
  newCategory(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          customController.clear();
          return AlertDialog(
            title: Text(catLang['new_category'][lang]),
            content: Wrap(
              children: [CategoryForm()],
            ),
          );
        });
  }

  Widget build(BuildContext context) {
    return SpeedDial(
      marginRight: (MediaQuery.of(context).size.width - 50) / 2,
      marginBottom: -25,
      animatedIcon: AnimatedIcons.menu_close,
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.fastfood,
            color: Colors.white,
          ),
          label: 'New Item',
          onTap: () {
            print('tapped');
            return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    //TODO: Change the title to create
                    title: Text('${genLang['edit'][lang]}'),
                    content: Wrap(
                      children: <Widget>[AddForm()],
                    ),
                  );
                });
          },
        ),
        SpeedDialChild(
          child: Icon(
            Icons.category,
            color: Colors.white,
          ),
          label: 'New Category',
          onTap: () {
            print('tapped');
            return newCategory(context);
          },
        ),
      ],
    );
  }
}
