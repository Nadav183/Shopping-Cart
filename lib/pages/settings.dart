import 'package:flutter/material.dart';
import 'package:organizer/style/designStyle.dart';
import 'package:organizer/style/lang.dart';

class Settings extends StatefulWidget {
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              setLang['settings'][lang],
              style: text['header'],
            ),
          ),
          ListTile(
            title: FlatButton(
              child: Text(setLang['nothing'][lang]),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            leading: Icon(Icons.keyboard_return),
          ),
        ],
      ),
    );
  }
}
