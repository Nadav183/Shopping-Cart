import 'package:flutter/material.dart';

class Item {
  String name;
  double pricePerUnit;
  int amountInStock;
  int amountBase;

  Item({this.name, this.pricePerUnit, this.amountInStock = 0, this.amountBase});
}