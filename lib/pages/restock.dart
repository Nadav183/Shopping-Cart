import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:organizer/assets/expansionTiles.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/db/database.dart';
import 'package:organizer/events/item_event.dart';

class ReStock extends StatefulWidget {
  @override
  _ReStockState createState() => _ReStockState();
}

class _ReStockState extends State<ReStock>{
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
          return ListView.builder(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 55),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: itemList.length,
            itemBuilder: (context, i) {
              final item = itemList[i];
              return Card(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Slidable(
                    key: Key('$i'),
                    actionPane: SlidableScrollActionPane(),
                    actionExtentRatio: 0.25,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Empty',
                        icon: Icons.delete_outline,
                        color: Colors.red,
                        onTap: (){
                          item.amountInStock = 0;
                          DatabaseProvider.db.update(item);
                          BlocProvider.of<ItemBloc>(context).add(
                              ItemEvent.update(item)
                          );
                        },
                      ),
                    ],
                    child: ReStockExpansionTile(itemList[i]),
                  ),
                ),

              );
            },
          );
        },
        listener: (BuildContext context, itemList) {},
      ),
    );
  }
}