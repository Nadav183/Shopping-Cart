import 'package:flutter/material.dart';

import 'pages/index.dart';
import 'pages/shop.dart';
import 'style/designStyle.dart';
import 'assets/drawer.dart';
import 'pages/restock.dart';
//import './database.dart';
import 'assets/float.dart';
import 'pages/addForm.dart';

void main() async => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final _formKey = GlobalKey<FormState>();
  var curPage = 'index';
  var bodyPage = {
    'index': [Index(),'Main',Icon(Icons.format_list_bulleted)],
    'shop':[Shop(),'Shopping List', Icon(Icons.shopping_basket)],
    'restock':[ReStock(),'ReStock Items', Icon(Icons.playlist_add)],
  };
  void _changePage(String page) => setState(() {curPage = page;});
  void pushAddForm(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddForm())
    );
    print('pushAddForm was called');
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
        appBar: AppBar(title: Text('My App',style: text['header'])),
        body: (bodyPage[curPage][0]),
        drawer: myDrawer(_changePage, bodyPage),
      floatingActionButton: myFloatingButton(),
    )
    );
  }
}