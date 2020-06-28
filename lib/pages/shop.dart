import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/expansionTiles.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/db/database.dart';
import 'package:organizer/events/item_event.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop>{
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
    return Container(
      padding: EdgeInsets.all(16),
      child: BlocConsumer<ItemBloc, List<Item>>(
        buildWhen: (List<Item> previous, List<Item> current) {
          return true;
        },
        listenWhen: (List<Item> previous, List<Item> current) {
          if((current != previous) && (previous.length != 0)){
            return true;
          }
          return false;
        },
        builder: (context, itemList){
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              if (itemList[index].amountInStock<itemList[index].amountBase){
                return Card(
                  child: ShopExpansionTile(itemList[index]),
                );
              }
              return null;
            },
          );
        },
        listener: (BuildContext context, itemList) {
      },
      ),
    );
  }
}