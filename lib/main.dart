import 'package:flutter/material.dart';

import 'pages/index.dart';
import 'pages/shop.dart';
import 'style/designStyle.dart';
import 'assets/drawer.dart';
import 'pages/restock.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var curPage = 'index';
  var bodyPage = {
    'index': [Index(),'Main'],
    'shop':[Shop(),'Shopping List'],
    'restock':[ReStock(),'ReStock Items'],
  };
  void _changePage(String page) => setState(() {curPage = page;});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
        appBar: AppBar(title: Text('My App',style: text['header'])),
        body: (bodyPage[curPage][0]),
        drawer: myDrawer(_changePage, bodyPage)
    )
    );
  }
}