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
    double cartPrice = 0;
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
          return Column(
            children: <Widget>[
              Text('Total Cart Price: $cartPrice', style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
              ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                padding: EdgeInsets.all(16),
                itemCount: itemList.length,
                itemBuilder: (context, index) {
                  if (itemList[index].amountBase-itemList[index].amountInStock>0){
                    return Card(
                      child: ShopExpansionTile(itemList[index]),
                    );
                  }
                  else {return SizedBox.shrink();}
                },
              ),
            ],
          );
        },
        listener: (BuildContext context, itemList) {
          cartPrice = 0;
          itemList.forEach((item) {
            var offset = item.amountBase-item.amountInStock;
            if (offset>0){
              cartPrice += offset*item.pricePerUnit;
            }
          });
        },
      ),
    );
  }
}