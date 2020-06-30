import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/bloc/item_bloc_delegate.dart';

//import 'assets/myAppBar.dart';
import 'assets/myAppBar.dart';
import 'bloc/item_bloc.dart';
import 'pages/index.dart';
import 'pages/shop.dart';
import 'assets/drawer.dart';
import 'pages/restock.dart';
import 'assets/float.dart';


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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ItemBloc>(
      create: (context) => ItemBloc(),
      child: MaterialApp(home: Scaffold(
        appBar: MyAppBar(bodyPage[curPage][1]),
        body: (bodyPage[curPage][0]),
        drawer: myDrawer(_changePage, bodyPage),
        floatingActionButton: MyFloatingButton(),
      )
      ),
    );
  }
}