import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/bloc_delegate.dart';
import 'style/designStyle.dart';
import 'style/lang.dart';
import 'assets/main_assets/myAppBar.dart';
import 'assets/objectClasses/settings_class.dart';
import 'bloc/item_bloc/item_bloc.dart';
import 'bloc/settings_bloc/settings_bloc.dart';
import 'pages/body_pages/index.dart';
import 'pages/body_pages/shop.dart';
import 'assets/main_assets/drawer.dart';
import 'assets/main_assets/float.dart';

void main() {
  // deals with bloc events
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
  // indicates the current page we are in, changed by _changePage()
  var curPage = 'index';

  // holds info for main pages of the app, the widget, the title, the icon
  var bodyPage = {
    'index': [
      Index(),
      mainLang['index'][lang],
      Icon(Icons.format_list_bulleted)
    ],
    'shop': [Shop(), mainLang['shop'][lang], Icon(Icons.shopping_basket)],
  };

  // refreshes the body page, just redefine the bodyPage variable as itself after a language change
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

  // groups together functions required for resetting a page
  void resetPage() {
    refreshBody();
    refreshStyle(); // from designStyle.dart
  }

  // sets the current page
  void _changePage(String page) => setState(() {
        curPage = page;
      });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsBloc>(
      create: (context) => SettingsBloc(),
      child: BlocProvider<ItemBloc>(
        create: (context) => ItemBloc(),
        child: BlocConsumer<SettingsBloc, Settings>(
          buildWhen: (Settings previous, Settings current) {
            // build when settings are changed
            if (previous != current) {
              print('built');
              return true;
            } else
              return false;
          },
          listenWhen: (Settings previous, Settings current) {
            // listens for a settings change
            if (previous != current) {
              return true;
            } else
              return false;
          },
          builder: (context, settings) {
            // sets the lang, theme and currency to be taken from the bloc
            lang = settings.language; // from lang.dart
            curTheme = settings.theme; // from designStyle.dart
            currentCurrency = settings.currency; // from designStyle.dart
            resetPage();

            return MaterialApp(
              home: Directionality(
                textDirection: dirLang['genDir'][lang],
                child: Scaffold(
                  appBar: MyAppBar(bodyPage[curPage][1]),
                  body: (bodyPage[curPage][0]),
                  drawer: myDrawer(_changePage, bodyPage),
                  floatingActionButton: MyFloatingButton(),
                ),
              ),
            );
          },
          listener: (BuildContext context, Settings state) {},
        ),
      ),
    );
  }
}
