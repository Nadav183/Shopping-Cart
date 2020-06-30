import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var text = {
  'header': headerTextStyle,
  'drawerOption': drawerOptionStyle,
  'buttonText': buttonTextStyle,
  'cart': cartPriceStyle,
};

var currency = {};

Function ils = NumberFormat.simpleCurrency(name:'ILS').format;

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