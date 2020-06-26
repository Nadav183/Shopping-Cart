import 'dart:async';
import './assets/item.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> groceryDatabase() async{
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'groceries_database.db'),
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE groceries(id INTEGER PRIMARY KEY, name TEXT, ppu REAL, amountBase INTEGER, amountInStock INTEGER)"
      );
    },
    version: 1,
  );
  return database;
}

var database = groceryDatabase();

Future<void> insertItem(Item item) async {
  final Database db = await database;
  await db.insert(
    'groceries',
    item.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
}

final onion = Item(
  id: 0,
  name: 'Onion',
  pricePerUnit: 2.3,
  amountInStock: 5,
  amountBase: 7,
);

void main() async{
  await insertItem(onion);
}