import 'package:flutter/material.dart';
import '../style/designStyle.dart';

Widget myDrawer(Function func, Map pages) {
  return Builder(
    builder: (context) => Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Options', style: text['header']),
          ),
          ...((pages.keys).map((pageKey) {
            return Center(child: ListTile(
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
      )
    )
  );
}