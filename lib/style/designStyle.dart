import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

//called as - style: text[type]

var themes = ['default','alt'];
var currencies = ['ILS','USD','GBP','JPY'];

var curTheme = 'alt';

var currentCurrency = 'ILS';

var text = {
  'header': headerTextChooser[curTheme],
  'drawerOption': drawerOptionStyle,
  'buttonText': buttonTextStyle,
  'cart': cartPriceStyle,
  'subtitle': subtitleStyle,
  'ddButton': ddButtonStyle,
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
  currency = NumberFormat.simpleCurrency(name: currentCurrency).format;
}





var headerTextChooser = {
  'default': TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  ),
  'alt': TextStyle(
    color: Colors.green,
    fontSize: 50,
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