import 'package:flutter/material.dart';
import 'package:organizer/style/lang.dart';
import 'package:organizer/style/designStyle.dart';

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
        ...((pages.keys).map((pageKey) {
          return Center(
            child: ListTile(
              key: Key('${pageKey}_listTile'),
              leading: pages[pageKey][2],
              title: Text('${pages[pageKey][1]}', style: text['drawerOption']),
              onTap: () {
                func(pageKey);
                Navigator.pop(context);
              },
            ),
          );
        })),
      ],
    ));
  });
}
