import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:organizer/assets/general_assets/categoryForm.dart';

import '../../style/designStyle.dart';
import '../../style/lang.dart';
import '../../pages/sub_pages/addForm.dart';

class MyFloatingButton extends FloatingActionButton {
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: Row(
        children: <Widget>[
          Icon(
            Icons.add,
            color: Colors.white,
          ),
          SizedBox(width: 5),
          Text(
            fltLang['add'][lang],
            style: text['buttonText'],
          )
        ],
      ),
      tooltip: fltLang['add_tltp'][lang],
      backgroundColor: Colors.green,
      onPressed: () {
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
