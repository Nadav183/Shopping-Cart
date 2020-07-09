import 'package:flutter/material.dart';

import '../../pages/sub_pages/settings.dart';
import '../../style/designStyle.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String titleText;

  MyAppBar(this.titleText);

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: appBarStyle['bgColor'],
      title: Text(
        widget.titleText,
        style: text['header'],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => SettingsView()));
          },
        ),
      ],
    );
  }
}
