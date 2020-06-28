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
          if((current.length != previous.length) && (previous.length != 0)){
            return true;
          }
          return true;
        },
        builder: (context, itemList){
          return ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            padding: EdgeInsets.all(16),
            itemCount: itemList.length,
            itemBuilder: (context, index) {
              print('${itemList[index].name}: ${itemList[index].amountBase-itemList[index].amountInStock} res: ${itemList[index].amountBase > itemList[index].amountInStock}');
              if ((itemList[index].amountBase-itemList[index].amountInStock)>0){
                return Card(
                  child: ShopExpansionTile(itemList[index]),
                );
              }
              else {return SizedBox.shrink();}
            },
          );
        },
        listener: (BuildContext context, itemList) {
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('Added'),
            ),
          );
        },
      ),
    );
  }
}

class Shop2 extends StatefulWidget {
  @override
  _Shop2State createState() => _Shop2State();
}

class _Shop2State extends State<Shop2>{
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
          if((current.length != previous.length) && (previous.length != 0)){
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
              if (itemList[index].amountBase>=itemList[index].amountInStock){
                return Card(
                  child: ShopExpansionTile(itemList[index]),
                );
              }
              return null;
            },
          );
        }, listener: (BuildContext context, itemList) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Added'),
          ),
        );
      },
      ),
    );
  }
}