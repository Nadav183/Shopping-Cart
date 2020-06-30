
import 'package:flutter/material.dart';
import 'package:organizer/pages/addForm.dart';
import 'package:organizer/pages/settings.dart';
import 'package:organizer/style/designStyle.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String titleText;
  MyAppBar(this.titleText);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar>{
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(widget.titleText, style: text['header'],),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Settings())
            );
          },
        ),
      ],
    );
  }

}