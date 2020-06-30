import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/expansionTiles.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/db/database.dart';
import 'package:organizer/events/item_event.dart';

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
              itemCount: itemList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: IndexExpansionTile(itemList[index]),
                );
              },
            );
          },
          listener: (BuildContext context, itemList) {

            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('Updated'),
              ),
            );
          },
        ),
      ),
    );
  }
}