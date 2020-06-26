import 'package:flutter/material.dart';

class Item {
  int id;
  String name;
  double pricePerUnit;
  int amountInStock;
  int amountBase;

  Item({this.id, this.name, this.pricePerUnit, this.amountInStock = 0, this.amountBase});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'ppu': pricePerUnit,
      'amountInStock': amountInStock,
      'amountBase': amountBase,
    };
  }
}