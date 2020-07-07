import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/bloc/item_bloc_delegate.dart';
import 'package:organizer/style/designStyle.dart';
import 'package:organizer/style/lang.dart';
import 'package:organizer/assets/myAppBar.dart';
import 'package:organizer/assets/settings_class.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/bloc/settings_bloc/settings_bloc.dart';
import 'package:organizer/pages/index.dart';
import 'package:organizer/pages/shop.dart';
import 'package:organizer/assets/drawer.dart';
import 'package:organizer/assets/float.dart';

void main() {
  BlocSupervisor.delegate = OrganizerBlocDelegate();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  var curPage = 'index';
  var bodyPage = {
    'index': [
      Index(),
      mainLang['index'][lang],
      Icon(Icons.format_list_bulleted)
    ],
    'shop': [Shop(), mainLang['shop'][lang], Icon(Icons.shopping_basket)],
  };

  void refreshBody() {
    bodyPage = {
      'index': [
        Index(),
        mainLang['index'][lang],
        Icon(Icons.format_list_bulleted)
      ],
      'shop': [Shop(), mainLang['shop'][lang], Icon(Icons.shopping_basket)],
    };
  }

  void resetPage() {
    refreshBody();
    refreshStyle();
  }

  void _changePage(String page) => setState(() {
        curPage = page;
      });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(),
      child: BlocConsumer<SettingsBloc, Settings>(
        buildWhen: (Settings previous, Settings current) {
          if (previous != current) {
            print('built');
            return true;
          } else
            return false;
        },
        listenWhen: (Settings previous, Settings current) {
          if (previous != current) {
            return true;
          } else
            return false;
        },
        builder: (context, settings) {
          lang = settings.language;
          curTheme = settings.theme;
          currentCurrency = settings.currency;
          resetPage();
          return MaterialApp(
            home: Directionality(
              textDirection: dirLang['genDir'][lang],
              child: BlocProvider<ItemBloc>(
                create: (context) => ItemBloc(),
                child: Scaffold(
                  appBar: MyAppBar(bodyPage[curPage][1]),
                  body: (bodyPage[curPage][0]),
                  drawer: myDrawer(_changePage, bodyPage),
                  floatingActionButton: MyFloatingButton(),
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, Settings state) {},
      ),
    );
  }
}
