import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//called as - style: text[type]

final Color primaryColor = Color.fromRGBO(246, 166, 30, 96.0);
final Color primaryColorLight = Color.fromRGBO(255, 182, 56, 100.0);
final Color primaryColorDark = Color.fromRGBO(168, 110, 10, 66.0);
final Color secondaryColor = Color.fromRGBO(29, 134, 245, 96.0);
final Color secondaryColorDark = Color.fromRGBO(0, 81, 168, 66.0);

var themes = ['default', 'alt'];
var currencies = ['ILS', 'USD', 'GBP', 'JPY'];

var curTheme = 'alt';
var showControl = false;
var currentCurrency = 'ILS';

var text = {
  'header': headerTextStyle,
  'drawerOption': drawerOptionStyle,
  'buttonText': buttonTextStyle,
  'cart': cartPriceStyle,
  'subtitle': subtitleStyle,
};

var colors = {
  'saveButton': primaryColorDark,
  'cancelButton': secondaryColor,
  'buttonText': buttonTextStyle,
  'cart': cartPriceStyle,
  'subtitle': subtitleStyle,
};

var appBarStyle = {
  'bgColor': primaryColor,
  'theme': AppBarTheme(
    color: primaryColor,
    elevation: 52,
  ),
};

var drawerStyle = {
  'decoration': BoxDecoration(
    color: primaryColor,
  )
};

Function currency = NumberFormat.simpleCurrency(name: currentCurrency).format;

void refreshStyle(){
  currency = NumberFormat.simpleCurrency(name: currentCurrency).format;
}

var headerTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 28,
  fontWeight: FontWeight.bold,
);

var drawerOptionStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
);

var buttonTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

var cartPriceStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

var subtitleStyle = TextStyle(
  color: Colors.grey,
  fontSize: 14,
  fontStyle: FontStyle.italic,
);