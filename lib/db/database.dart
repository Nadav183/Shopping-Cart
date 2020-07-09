import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../assets/category_class.dart';
import '../assets/item.dart';



class DatabaseProvider {
  static const String TABLE_GROCERIES = "groceries";
  static const String COLUMN_ID = "id";
  static const String COLUMN_NAME = "name";
  static const String COLUMN_PPU = "ppu";
  static const String COLUMN_BASE = "base";
  static const String COLUMN_STOCK = "stock";

  static const String TABLE_CATEGORIES = "categories";
  static const String COLUMN_CATEGORYID = "categoryID";
  static const String COLUMN_CATEGORYNAME = "categoryName";

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
      version: 2,
      onCreate: (Database database, int version) async {
        print("Creating food table");
        await database.execute(
          "CREATE TABLE $TABLE_GROCERIES ("
          "$COLUMN_ID INTEGER PRIMARY KEY,"
          "$COLUMN_NAME TEXT,"
          "$COLUMN_PPU REAL,"
          "$COLUMN_BASE REAL,"
          "$COLUMN_STOCK REAL,"
          "$COLUMN_CATEGORYID INTEGER"
          ")",
        );
        await database.execute(
          "CREATE TABLE $TABLE_CATEGORIES ("
          "$COLUMN_CATEGORYID INTEGER PRIMARY KEY,"
          "$COLUMN_CATEGORYNAME TEXT"
          ")",
        );
      },
      onUpgrade: (Database database, int oldVersion, int newVersion) async {
        if (oldVersion < 2) {
          print('renaming table');
          await database
              .execute("ALTER TABLE $TABLE_GROCERIES RENAME TO _OLDTABLE");
          print('creating new table');
          await database.execute("CREATE TABLE $TABLE_GROCERIES ("
              "$COLUMN_ID INTEGER PRIMARY KEY,"
              "$COLUMN_NAME TEXT,"
              "$COLUMN_PPU REAL,"
              "$COLUMN_BASE REAL,"
              "$COLUMN_STOCK REAL"
              ")");
          print('copying all items');
          await database.execute(
              "INSERT INTO $TABLE_GROCERIES($COLUMN_NAME, $COLUMN_PPU, $COLUMN_BASE, $COLUMN_STOCK) "
              "SELECT $COLUMN_NAME, $COLUMN_PPU, $COLUMN_BASE, $COLUMN_STOCK "
              "FROM _OLDTABLE");
          print('done upgrading database');
        }
        if (oldVersion < 3) {
          print('creating categories table');
          await database.execute(
            "CREATE TABLE $TABLE_CATEGORIES ("
            "$COLUMN_CATEGORYID INTEGER PRIMARY KEY,"
            "$COLUMN_CATEGORYNAME TEXT"
            ")",
          );
          print('adding new categoryID column');
          await database.execute(
            "ALTER TABLE $TABLE_GROCERIES ADD $COLUMN_CATEGORYID INTEGER"
          );
          print('finished updating to version 3');
        }
      },
    );
  }

  Future<List<Item>> getItems() async {
    final db = await database;

    var items = await db.query(
      TABLE_GROCERIES,
      columns: [
        COLUMN_ID,
        COLUMN_NAME,
        COLUMN_PPU,
        COLUMN_BASE,
        COLUMN_STOCK,
      ],
    );
    List<Item> itemList = List<Item>();
    items.forEach((curItem) {
      Item item = Item.fromMap(curItem);
      itemList.add(item);
    });
    return itemList;
  }

  Future<List<Item>> getShopItems() async {
    final db = await database;

    var items = await db.query(TABLE_GROCERIES,
        columns: [
          COLUMN_ID,
          COLUMN_NAME,
          COLUMN_PPU,
          COLUMN_BASE,
          COLUMN_STOCK,
        ],
        where: "$COLUMN_STOCK<$COLUMN_BASE");
    List<Item> itemList = List<Item>();
    items.forEach((curItem) {
      Item item = Item.fromMap(curItem);
      itemList.add(item);
    });
    return itemList;
  }

  Future<Item> insert(Item item) async {
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

  Future<int> remove(int id) async {
    final db = await database;
    return await db.delete(TABLE_GROCERIES, where: "id = ?", whereArgs: [id]);
  }

  Future<int> update(Item item) async {
    final db = await database;
    return await db.update(
      TABLE_GROCERIES,
      item.toMap(),
      where: "id = ?",
      whereArgs: [item.id],
    );
  }

  Future<List<Category>>getCategories() async {
    final db = await database;

    var categories = await db.query(
      TABLE_CATEGORIES,
      columns: [
        COLUMN_CATEGORYID,
        COLUMN_CATEGORYNAME,
      ],
    );

    List<Category> categoryList = List<Category>();
    categories.forEach((curCategory) {
      Category category = Category.fromMap(curCategory);
      categoryList.add(category);
    });
    return categoryList;
  }

  Future<Category> insertCategory(Category category) async {
    final db = await database;
    category.id = await db.insert(TABLE_CATEGORIES, category.toMap());
    print('Inserting new item:\n'
        'name: ${category.name}\n'
        'id: ${category.id}\n');
    return category;
  }

  Future<int> removeCategory(int id) async {
    final db = await database;
    return await db.delete(TABLE_GROCERIES, where: "id = ?", whereArgs: [id]);
  }

  Future<int> updateCategory(Category category) async {
    final db = await database;
    return await db.update(
      TABLE_CATEGORIES,
      category.toMap(),
      where: "id = ?",
      whereArgs: [category.id],
    );
  }

  Future<void> deleteDatabase() async {
    var dbPath = await getDatabasesPath();
    databaseFactory.deleteDatabase(join(dbPath, 'groceriesDB.db'));
  }
}
