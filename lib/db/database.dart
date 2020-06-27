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
    final db = await database;

    var items = await db.query(
      TABLE_GROCERIES,
      columns: [
        COLUMN_ID,
        COLUMN_NAME,
        COLUMN_PPU,
        COLUMN_BASE,
        COLUMN_STOCK,
      ]
    );
    List<Item> itemList = List<Item>();
    items.forEach((curItem){
      Item item = Item.fromMap(curItem);
      itemList.add(item);
    });
    return itemList;
  }

  Future<Item> insert (Item item) async {
    final db = await database;
    item.id = await db.insert(TABLE_GROCERIES, item.toMap());
    print('Inserting new item:\n'
          'name: ${item.name}\n'
          'ppu: ${item.pricePerUnit}\n'
          'stock: ${item.amountInStock}\n'
          'base: ${item.amountBase}\n'
          'id: ${item.id}\n');
    return item;
  }
  Future<void> deleteDatabase() async {
    var dbPath = await getDatabasesPath();
    databaseFactory.deleteDatabase(join(dbPath,'groceriesDB.db'));
  }
}