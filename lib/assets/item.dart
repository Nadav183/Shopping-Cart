import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/item_bloc.dart';
import '../db/database.dart';
import '../events/item_event.dart';

class Item {
  int id;
  String name;
  double pricePerUnit;
  double amountInStock;
  double amountBase;
  int categoryID;

  Item(
      {this.id,
      this.name,
      this.pricePerUnit,
      this.amountInStock = 0,
      this.amountBase,
      this.categoryID});

  ///maps the keys of the DB columns to the values of an Item
  ///If the id is null it will be automatically set on DB side as PK
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_NAME: name,
      DatabaseProvider.COLUMN_PPU: pricePerUnit,
      DatabaseProvider.COLUMN_STOCK: amountInStock,
      DatabaseProvider.COLUMN_BASE: amountBase,
    };
    if (id != null) {
      map[DatabaseProvider.COLUMN_ID] = id;
    }
    return map;
  }

  ///converts a map from the DB to an Item
  Item.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_ID];
    name = map[DatabaseProvider.COLUMN_NAME];
    pricePerUnit = map[DatabaseProvider.COLUMN_PPU];
    amountInStock = map[DatabaseProvider.COLUMN_STOCK];
    amountBase = map[DatabaseProvider.COLUMN_BASE];
  }

  // handles inserting the item to the Database and calling the Bloc event for
  // inserting an item to the ItemBloc
  Future<void> insertToDB(BuildContext context) async {
    DatabaseProvider.db.insert(this).then((insertedItem){
      BlocProvider.of<ItemBloc>(context).add(
          ItemEvent.insert(insertedItem)
      );
    });
  }

  // handles removing the item from the Database and calling the Bloc event for
  // removing an item from the ItemBloc
  Future<void> removeFromDB(BuildContext context) async {
    DatabaseProvider.db.remove(this.id).then((id){
      BlocProvider.of<ItemBloc>(context).add(
        ItemEvent.delete(this)
      );
    });
  }

  // handles updating the item in the Database and calling the Bloc event for
  // updating an item in the ItemBloc
  Future<void> updateInDB(BuildContext context) async {
    DatabaseProvider.db.update(this).then((id){
      BlocProvider.of<ItemBloc>(context).add(
          ItemEvent.update(this)
      );
    });
  }
}
