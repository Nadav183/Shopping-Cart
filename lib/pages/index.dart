import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../assets/expansionTiles.dart';
import '../assets/item.dart';
import '../bloc/item_bloc.dart';
import '../bloc/settings_bloc/settings_bloc.dart';
import '../db/database.dart';
import '../db/preferencesDB.dart';
import '../events/item_event.dart';
import '../events/settings_event.dart';
import '../style/lang.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index>{

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  Future<Null> _refresh() async {
    DatabaseProvider.db.getItems().then(
          (itemList) {
        BlocProvider.of<ItemBloc>(context).add(ItemEvent.setItems(itemList));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getItems().then(
          (itemList) {
        BlocProvider.of<ItemBloc>(context).add(ItemEvent.setItems(itemList));
      },
    );
    getPreferences().then((prefs){
      BlocProvider.of<SettingsBloc>(context).add(
        SettingsEvent.update(prefs)
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      key: _refreshIndicatorKey,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: BlocConsumer<ItemBloc, List<Item>>(
          buildWhen: (List<Item> previous, List<Item> current) {
            return true;
          },
          listenWhen: (List<Item> previous, List<Item> current) {
            if((current.length != previous.length) && (previous.length != 0)){
              return true;
            }
            return false;
          },
          builder: (context, itemList){
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 55),
              itemCount: itemList.length+1,
              itemBuilder: (context, i) {
                if (i == 0){
                  return Container(
                    padding: EdgeInsets.only(left: 16, right: 45),
                    child: Row(
                      children: [
                        Expanded(child: Text(indLang['name'][lang],textAlign: dirLang['tile_left'][lang],)),
                        Text(indLang['stock'][lang], textAlign: dirLang['tile_right'][lang],),
                      ],
                    ),
                  );
                }
                i -= 1;
                return Card(
                  child: IndexExpansionTile(itemList[i]),
                );
              },
            );
          },
          listener: (BuildContext context, itemList) {

            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(genLang['updated'][lang]),
              ),
            );
          },
        ),
      ),
    );
  }
}