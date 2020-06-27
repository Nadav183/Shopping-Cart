import 'dart:async';
import '../assets/item.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String TABLE_GROCERIES = "groceries";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_PPU = "ppu";
  static const String COLUMN_BASE = "base";
  static const String COLUMN_STOCK = "stock";

  DatabaseProvider._();
  static final DatabaseProvider db = DatabaseProvider._();

  Database _database;

  Future<Database> get database async {
    print("database getter called");
    if (_database != null) {
      return _database;
    }
    _database = await createDatabase();
    return _database;
  }
  Future<Database> createDatabase() async {
    String dbPath = await getDatabasesPath();
    return await openDatabase(
      join(dbPath, 'groceriesDB.db'),
      version: 1,
      onCreate: (Database database, int version) async {
        print("Creating food table");
        await database.execute(
          "CREATE TABLE $TABLE_GROCERIES ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT,"
          "$COLUMN_PPU REAL,"
          "$COLUMN_BASE INTEGER,"
          "$COLUMN_STOCK INTEGER"
          ")",
        );
      },
    );
  }
  Future<List<Item>> getItems() async{

  }

}


final onion = Item(
  id: 0,
  name: 'Onion',
  pricePerUnit: 2.3,
  amountInStock: 5,
  amountBase: 7,
);

var items = [onion,];