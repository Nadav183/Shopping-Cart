import 'package:flutter/material.dart';

import './index.dart';
import './shop.dart';
import './designStyle.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var curPage = 'index';
  var bodyPage = {'index': Index(),'shop':Shop()};
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
        appBar: AppBar(title: Text('My App',style: text['header'])),
        body: (bodyPage[curPage]),
        drawer: Builder(builder: (context) => Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Options',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('View Shopping List'),
                onTap: () {
                  setState(() {curPage = 'shop';});
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        ),
    )
    );
  }
}