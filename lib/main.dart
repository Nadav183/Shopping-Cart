import 'package:flutter/material.dart';

import './index.dart';
import './item.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var curPage = 'index';
  var bodyPage = {'index': Index(),};
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(
        appBar: AppBar(title: Text('My App')),
        body: (bodyPage[curPage]),
    )
    );
  }
}