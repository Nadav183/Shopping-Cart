import 'package:flutter/material.dart';

import '../style/lang.dart';
import '../style/designStyle.dart';

Widget myDrawer(Function func, Map pages) {
  return Builder(builder: (context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: drawerStyle['decoration'],
            child: Text(drawerLang['options'][lang], style: text['header']),
          ),
          // takes the keys of the pages map, that holds the info about each
          // page of the app and maps it into a list tile with the option to
          // go to that page using the _changePage function from main
          ...((pages.keys).map((pageKey) {
            return Center(
              child: ListTile(
                key: Key('${pageKey}_listTile'),
                leading: pages[pageKey][2],
                title:
                    Text('${pages[pageKey][1]}', style: text['drawerOption']),
                onTap: () {
                  func(pageKey);
                  Navigator.pop(context);
                },
              ),
            );
          })),
        ],
      ),
    );
  });
}
