import 'package:shared_preferences/shared_preferences.dart';

import '../assets/objectClasses/settings_class.dart';

Future<Settings> getPreferences() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  print('getting preferences');
  var language = prefs.getString('language');
  var currency = prefs.getString('currency');
  var theme = prefs.getString('theme');
  var showUnCategorized = prefs.getBool('show');
  if (language == null) {
    language = 'EN';
  }
  if (currency == null) {
    currency = 'ILS';
  }
  if (theme == null) {
    theme = 'default';
  }
  if (showUnCategorized == null) {
    showUnCategorized = false;
  }

  var settings = Settings(
    language: language,
    currency: currency,
    theme: theme,
    showUnCategorized: showUnCategorized,
  );
  setPreferences(settings);

  return settings;
}
Future<bool> setPreferences(Settings settings) async {
  var language = settings.language;
  var currency = settings.currency;
  var theme = settings.theme;
  var showUnCategorized = settings.showUnCategorized;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('language', language);
  prefs.setString('theme', theme);
  prefs.setString('currency', currency);
  prefs.setBool('show', showUnCategorized);
  return true;
}