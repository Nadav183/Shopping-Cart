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
