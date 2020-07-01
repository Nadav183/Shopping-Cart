import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/expansionTiles.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/db/database.dart';
import 'package:organizer/events/item_event.dart';
import 'package:organizer/style/designStyle.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop>{
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
    double cartPrice = 0;
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
            return true;
          },
          builder: (context, itemList){
            return Container(
              child: ListView(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 55),
                scrollDirection: Axis.vertical,
                children: List.generate(itemList.length+1, (i) {
                  if (i == 0){
                    return Text(
                      'Total Price: ${ils(cartPrice)}',
                      style: text['cart'],
                      textAlign: TextAlign.center,
                    );
                  }
                  i -= 1;
                  final item = itemList[i];
                  if (item.amountBase-item.amountInStock>0){
                    return Card(
                      key: Key('$i'),
                      child: ShopExpansionTile(itemList[i]),
                    );
                  }
                  else {return SizedBox.shrink();}
                }),
              ),
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
      ),
    );
  }
}