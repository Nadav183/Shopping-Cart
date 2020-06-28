import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/bloc/item_bloc_delegate.dart';

import 'bloc/item_bloc.dart';
import 'db/database.dart';
import 'events/item_event.dart';
import 'pages/index.dart';
import 'pages/shop.dart';
import 'style/designStyle.dart';
import 'assets/drawer.dart';
import 'pages/restock.dart';
import 'assets/float.dart';

//void main() async => runApp(MyApp());

void main() {
  BlocSupervisor.delegate = ItemBlocDelegate();
  runApp(MyApp());
}

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
  void _emptySetState() => setState(() {bodyPage['index'][0] = Index();});
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemBloc>(
      create: (context) => ItemBloc(),
      child: MaterialApp(home: Scaffold(
        appBar: AppBar(title: Text(bodyPage[curPage][1],style: text['header'])),
        body: (bodyPage[curPage][0]),
        endDrawer: myDrawer(_changePage, bodyPage),
        floatingActionButton: myFloatingButton(_emptySetState),
      )
      ),
    );
  }
}