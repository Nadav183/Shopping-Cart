

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:organizer/style/designStyle.dart';

class Settings extends StatefulWidget {

  _SettingsState createState() => _SettingsState();

}

class _SettingsState extends State<Settings>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Settings', style: text['header'],),
          ),
          ListTile(
            title: FlatButton(
                child: Text('Nothing to see here'),
                onPressed: () {Navigator.pop(context);},
            ),
            leading: Icon(Icons.keyboard_return),
          ),
        ],
      ),
    );
  }
}