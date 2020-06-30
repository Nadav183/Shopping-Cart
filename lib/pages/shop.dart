import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
            return Column(
              children: <Widget>[
                Text('Total Cart Price: ${ils(cartPrice)}', style: text['cart'],),
                ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 55),
                  itemCount: itemList.length,
                  itemBuilder: (context, i) {
                    final item = itemList[i];
                    if (item.amountBase-item.amountInStock>0){
                      return Card(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Slidable(
                            key: Key('$i'),
                            actionPane: SlidableScrollActionPane(),
                            actionExtentRatio: 0.25,
                            actions: <Widget>[
                              IconSlideAction(
                                caption: 'Fill',
                                icon: Icons.check,
                                color: Colors.green,
                                onTap: (){
                                  item.amountInStock = item.amountBase;
                                  DatabaseProvider.db.update(item);
                                  BlocProvider.of<ItemBloc>(context).add(
                                      ItemEvent.update(item)
                                  );
                                },
                              ),
                            ],
                            child: ShopExpansionTile(itemList[i]),
                          ),
                        ),

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
      ),
    );
  }
}