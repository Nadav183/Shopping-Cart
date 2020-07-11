import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/settings_bloc/settings_bloc.dart';
import '../../db/preferencesDB.dart';
import '../../events/settings_event.dart';
import '../../bloc/category_bloc/category_bloc.dart';
import '../../events/category_event.dart';
import '../../assets/general_assets/expansionTiles.dart';
import '../../assets/objectClasses/item.dart';
import '../../bloc/item_bloc/item_bloc.dart';
import '../../db/database.dart';
import '../../events/item_event.dart';
import '../../style/lang.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Future<void> _gatherBlocs() async {
    DatabaseProvider.db.getCategories().then(
      (categoryList) {
        BlocProvider.of<CategoryBloc>(context)
            .add(CategoryEvent.setItems(categoryList));
      },
    );
    DatabaseProvider.db.getItems().then(
      (itemList) {
        itemList.forEach((item) {
          if (item.categoryID != null) {
            DatabaseProvider.db.getCategoryByID(item.categoryID).then((string) {
              setState(() {
                item.categoryName = string;
              });
            });
          } else {
            item.categoryName = 'No Category';
          }
        });
        BlocProvider.of<ItemBloc>(context).add(ItemEvent.setItems(itemList));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _gatherBlocs();
    getPreferences().then((settings) {
      BlocProvider.of<SettingsBloc>(context).add(
          SettingsEvent.update(settings)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _gatherBlocs,
      key: _refreshIndicatorKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: BlocConsumer<ItemBloc, List<Item>>(
          buildWhen: (List<Item> previous, List<Item> current) {
            return true;
          },
          builder: (context, itemList) {
            return ListView(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 55),
              children: [
                Container(
                  padding: EdgeInsets.only(left: 16, right: 45),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                            indLang['name'][lang],
                            textAlign: dirLang['tile_left'][lang],
                          )),
                      Text(
                        indLang['stock'][lang],
                        textAlign: dirLang['tile_right'][lang],
                      ),
                    ],
                  ),
                ),
                ...List.generate(itemList.length, (i) {
                  return Card(
                    child: IndexExpansionTile(itemList[i]),
                  );
                })
              ],
            );
          },
          listener: (BuildContext context, itemList) {
          },
        ),
      ),
    );
  }
}
