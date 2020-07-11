import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//called as - style: text[type]

var themes = ['default', 'alt'];
var currencies = ['ILS', 'USD', 'GBP', 'JPY'];

var curTheme = 'alt';
var showControl = false;
var currentCurrency = 'ILS';

var text = {
  'header': headerTextChooser[curTheme],
  'drawerOption': drawerOptionStyle,
  'buttonText': buttonTextStyle,
  'cart': cartPriceStyle,
  'subtitle': subtitleStyle,
  'ddButton': ddButtonStyle,
};

var appBarStyle = {
  'bgColor' : appBarStyleChooser[curTheme]['bgColor'],
  'theme' : appBarStyleChooser[curTheme]['theme'],
};

var drawerStyle = {
  'decoration': drawerDecoration[curTheme]
};

var drawerDecoration = {
  'default' : BoxDecoration(
    color: Colors.blue,
  ),
  'alt' : BoxDecoration(
    color: Colors.purple,
  ),
};

var appBarStyleChooser = {
  'default' : {
    'bgColor': Colors.blue,
    'theme' : AppBarTheme()
  },
  'alt': {
    'bgColor': Colors.purple,
    'theme' : AppBarTheme(
      color: Colors.purple,
      elevation: 52,
    ),
  }
};


Function currency = NumberFormat.simpleCurrency(name: currentCurrency).format;

void refreshStyle(){
  text = {
    'header': headerTextChooser[curTheme],
    'drawerOption': drawerOptionStyle,
    'buttonText': buttonTextStyle,
    'cart': cartPriceStyle,
    'subtitle': subtitleStyle,
  };

  appBarStyle = {
    'bgColor' : appBarStyleChooser[curTheme]['bgColor'],
  };

  drawerStyle = {
    'decoration': drawerDecoration[curTheme]
  };

  currency = NumberFormat.simpleCurrency(name: currentCurrency).format;
}

var headerTextChooser = {
  'default': TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  ),
  'alt': TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  )
};

var ddButtonStyle = TextStyle(

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