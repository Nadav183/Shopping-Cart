import '../db/database.dart';

class Item {
  int id;
  String name;
  double pricePerUnit;
  int amountInStock;
  int amountBase;

  Item({this.id, this.name, this.pricePerUnit, this.amountInStock = 0, this.amountBase});

  ///maps the keys of the DB columns to the values of an Item
  ///If the id is null it will be automatically set on DB side as PK
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_PPU: pricePerUnit,
      DatabaseProvider.COLUMN_STOCK: amountInStock,
      DatabaseProvider.COLUMN_BASE: amountBase,
    };
    if (id !=null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }
    return map;
  }

  ///converts a map from the DB to an Item
  Item.fromMap(Map<String, dynamic> map){
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
    pricePerUnit = map[DatabaseProvider.COLUMN_PPU];
    amountInStock = map[DatabaseProvider.COLUMN_STOCK];
    amountBase = map[DatabaseProvider.COLUMN_BASE];
  }
}