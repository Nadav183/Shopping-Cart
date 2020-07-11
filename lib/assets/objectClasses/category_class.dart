import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/category_bloc/category_bloc.dart';
import '../../db/database.dart';
import '../../events/category_event.dart';

class Category {
  int id;
  String name;

  Category({this.id, this.name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_CATEGORYNAME: name,
    };
    if (id != null) {
      map[DatabaseProvider.COLUMN_CATEGORYID] = id;
    }
    return map;
  }

  ///converts a map from the DB to an Item
  Category.fromMap(Map<String, dynamic> map) {
    id = map[DatabaseProvider.COLUMN_CATEGORYID];
    name = map[DatabaseProvider.COLUMN_CATEGORYNAME];
  }

  // handles inserting the item to the Database and calling the Bloc event for
  // inserting an item to the ItemBloc
  Future<void> insertToDB(BuildContext context) async {
    DatabaseProvider.db.insertCategory(this).then((insertedCategory){
      BlocProvider.of<CategoryBloc>(context).add(
          CategoryEvent.insert(insertedCategory)
      );
    });
  }

  // handles removing the item from the Database and calling the Bloc event for
  // removing an item from the ItemBloc
  Future<void> removeFromDB(BuildContext context) async {
    DatabaseProvider.db.removeCategory(this.id).then((id){
      BlocProvider.of<CategoryBloc>(context).add(
          CategoryEvent.delete(this)
      );
    });
  }

  // handles updating the item in the Database and calling the Bloc event for
  // updating an item in the ItemBloc
  Future<void> updateInDB(BuildContext context) async {
    DatabaseProvider.db.updateCategory(this).then((id){
      BlocProvider.of<CategoryBloc>(context).add(
          CategoryEvent.update(this)
      );
    });
  }
}