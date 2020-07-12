import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/category_bloc/category_bloc.dart';
import '../../db/database.dart';
import '../../events/category_event.dart';

class Category {
  int id;
  String name;
  bool display;

  Category({this.id, this.name, this.display = true});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      DatabaseProvider.COLUMN_CATEGORYNAME: name,
      DatabaseProvider.COLUMN_DISPLAY: display ? 1 : 0
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
    display = (map[DatabaseProvider.COLUMN_DISPLAY] == 1);
  }

  // handles inserting the item to the Database and calling the Bloc event for
  // inserting an item to the ItemBloc
  Future<void> insertToDB(BuildContext context) async {
    print('inserting');
    print('name: ${this.name}');
    print('display: ${this.display}');
    DatabaseProvider.db.insertCategory(this).then((insertedCategory) {
      BlocProvider.of<CategoryBloc>(context)
          .add(CategoryEvent.insert(insertedCategory));
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