import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc/settings_bloc.dart';
import '../../db/preferencesDB.dart';
import '../../events/settings_event.dart';
import '../../style/designStyle.dart';
import '../../style/lang.dart';
import '../../assets/objectClasses/settings_class.dart';

class SettingsView extends StatefulWidget {
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  String _langControl = lang;
  String _themeControl = curTheme;
  String _currencyControl = currentCurrency;
  bool _showControl = showControl;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: dirLang['genDir'][lang],
        child: Drawer(
          child: ListView(
            shrinkWrap: false,
            children: <Widget>[
              DrawerHeader(
                decoration: drawerStyle['decoration'],
                child: Text(
                  setLang['settings'][lang],
                  style: text['header'],
                ),
              ),
              ListTile(
                leading: Text(setLang['language'][lang]),
                title: Wrap(
                  children: <Widget>[
                    DropdownButton(
                      value: _langControl,
                      onChanged: (value) {
                        setState(() {
                          _langControl = value;
                        });
                      },
                      items: languages.map((language) {
                        return DropdownMenuItem(
                          value: language,
                          child: Text(setLang[language][lang]),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Text(setLang['theme'][lang]),
                title: Wrap(
                  children: <Widget>[
                    DropdownButton(
                      value: _themeControl,
                      onChanged: (value) {
                        setState(() {
                          _themeControl = value;
                        });
                      },
                      items: themes.map((theme) {
                        return DropdownMenuItem(
                          value: theme,
                          child: Text(setLang[theme][lang]),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              ListTile(
                leading: Text(setLang['currency'][lang]),
                title: Wrap(
                  children: <Widget>[
                    DropdownButton(
                      value: _currencyControl,
                      onChanged: (value) {
                        setState(() {
                          _currencyControl = value;
                        });
                      },
                      items: currencies.map((curr) {
                        return DropdownMenuItem(
                          value: curr,
                          child: Text(setLang[curr][lang]),
                        );
                      }).toList(),
                    )
                  ],
                ),
              ),
              SwitchListTile(
                title: Text(setLang['display_uncategorized'][lang]),
                value: _showControl,
                onChanged: (value) {
                  setState(() {
                    _showControl = value;
                  });
                },
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                child: Row(
                  children: <Widget>[
                    RaisedButton(
                      child: Text(
                        genLang['save'][lang],
                        style: text['buttonText'],
                      ),
                      color: Colors.green,
                      onPressed: () {
                        var newSettings = Settings(
                          theme: _themeControl,
                          language: _langControl,
                          currency: _currencyControl,
                          showUnCategorized: _showControl,
                        );
                        setPreferences(newSettings);
                        BlocProvider.of<SettingsBloc>(context)
                            .add(SettingsEvent.update(newSettings));
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(),
                    RaisedButton(
                      child: Text(
                        genLang['cancel'][lang],
                        style: text['buttonText'],
                      ),
                      color: Colors.blue,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
