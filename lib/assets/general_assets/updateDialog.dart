import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../assets/objectClasses/item.dart';
import '../../style/lang.dart';
import 'editForm.dart';

class UpdateDialog extends StatelessWidget {
  final Item item;

  UpdateDialog(this.item);

  deleteConfirmationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('${formLang['delete'][lang]} ${item.name}'),
            content: Text(
              '${formLang['confirm1'][lang]} \'${item.name}\' ${formLang['confirm2'][lang]}',
              maxLines: 5,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(genLang['yes'][lang]),
                onPressed: () {
                  item.removeFromDB(context);
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Wrap(
        children: [
          Container(
            child: Stack(
              children: [
                EditForm(item),
                Positioned(
                  right: 0.0,
                  child: IconButton(
                    onPressed: () {
                      deleteConfirmationDialog(context).then((res) {
                        if (res) {
                          Navigator.pop(context);
                        }
                      });
                    },
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
