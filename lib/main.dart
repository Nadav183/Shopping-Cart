import 'package:flutter/material.dart';

import 'pages/index.dart';
import 'pages/shop.dart';
import 'style/designStyle.dart';
import 'assets/drawer.dart';
import 'pages/restock.dart';
import './db/database.dart';
import 'assets/float.dart';

void main() async => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var itemsDatabase = [];
  var curPage = 'index';
  var bodyPage = {
    'index': [Index(),'Main',Icon(Icons.format_list_bulleted)],
    'shop':[Shop(),'Shopping List', Icon(Icons.shopping_basket)],
    'restock':[ReStock(),'ReStock Items', Icon(Icons.playlist_add)],
  };
  void _changePage(String page) => setState(() {curPage = page;});
  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getItems().then((itemList) {
      setState(() {
        itemsDatabase = itemList;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
        appBar: AppBar(title: Text(bodyPage[curPage][1],style: text['header'])),
        body: (bodyPage[curPage][0]),
        endDrawer: myDrawer(_changePage, bodyPage),
      floatingActionButton: myFloatingButton(),
    )
    );
  }
}