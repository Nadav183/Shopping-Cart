import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../assets/general_assets/expansionTiles.dart';
import '../../assets/objectClasses/item.dart';
import '../../bloc/item_bloc/item_bloc.dart';
import '../../db/database.dart';
import '../../events/item_event.dart';
import '../../style/designStyle.dart';
import '../../style/lang.dart';

class Shop extends StatefulWidget {
  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
          builder: (context, itemList) {
            cartPrice = 0;
            itemList.forEach((item) {
              var offset = item.amountBase - item.amountInStock;
              if (offset > 0) {
                cartPrice += offset * item.pricePerUnit;
              }
            });
            return Container(
              child: ListView(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 55),
                  scrollDirection: Axis.vertical,
                  children: [
                    Text(
                      '${shopLang['price'][lang]} ${currency(cartPrice)}',
                      style: text['cart'],
                      textAlign: TextAlign.center,
                    ),
                    ...List.generate(itemList.length, (i) {
                      var offset = itemList[i].amountBase -
                          itemList[i].amountInStock;
                      if (offset > 0) {
                        return Card(
                          key: Key('$i'),
                          child: ShopExpansionTile(itemList[i]),
                        );
                      }
                      else {
                        return SizedBox.shrink();
                      }
                    }),
                  ]),
            );
          },
          listener: (BuildContext context, itemList) {
            cartPrice = 0;
            itemList.forEach((item) {
              var offset = item.amountBase - item.amountInStock;
              if (offset > 0) {
                cartPrice += offset * item.pricePerUnit;
              }
            });
          },
        ),
      ),
    );
  }
}
