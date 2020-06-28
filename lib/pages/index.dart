import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/db/database.dart';
import 'package:organizer/events/item_event.dart';

class Index extends StatefulWidget {
  @override
  _IndexState createState() => _IndexState();
}

class _IndexState extends State<Index>{
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
              return Card(
                child: ExpansionTile(
                  title: Text(itemList[index].name),
                ),
              );
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

  /*
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child:Text('Item Name', textAlign: TextAlign.left)),
              Expanded(child:Text('Price Per Unit',textAlign: TextAlign.center)),
              Expanded(child:Text('Stock',textAlign: TextAlign.right)),
            ],
          ),
          Expanded(child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              ...((items).map((item) {
                if (item.name != null) {
                  return Card(
                      child: ExpansionTile(
                        title: Row(
                          children: <Widget>[
                            Expanded(child:Text('${item.name}', textAlign: TextAlign.left)),
                            Expanded(child:Text('${item.pricePerUnit}',textAlign: TextAlign.center)),
                            Expanded(child:Text('${item.amountInStock}',textAlign: TextAlign.right)),
                          ],
                        ),
                        trailing: Icon(Icons.more_vert),
                        children: <Widget>[
                          Text('Base Amount: ${item.amountBase}'),
                          Text('Need to buy ${item.amountBase-item.amountInStock} for ${(item.amountBase-item.amountInStock)*item.pricePerUnit} NIS'),
                        ],
                      )
                  );
                }
                else{
                  return Card(child: Text('Invalid'));
                }
              }))
            ],))
        ],
      ),
    );
  } */
}