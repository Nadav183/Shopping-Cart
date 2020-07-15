import 'package:flutter/material.dart';

import '../../pages/sub_pages/settings.dart';
import '../../style/designStyle.dart';

class MyBottomBar extends StatefulWidget {
  final Map<String, List<dynamic>> bodyPage;
  final Function func;

  MyBottomBar(this.bodyPage, this.func);

  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            widget.func(widget.bodyPage.keys.toList()[index]);
          });
        },
        items: [
          ...widget.bodyPage.keys.map((pageKey) {
            return BottomNavigationBarItem(
                title: Text(widget.bodyPage[pageKey][1]),
                icon: widget.bodyPage[pageKey][2]);
          })
        ]);
  }
}
