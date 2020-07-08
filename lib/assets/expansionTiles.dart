import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/db/database.dart';
import 'package:organizer/events/item_event.dart';
import 'package:organizer/style/designStyle.dart';
import 'package:organizer/style/lang.dart';
import 'package:organizer/assets/editForm.dart';

class IndexExpansionTile extends StatelessWidget {
  final Item item;

  IndexExpansionTile(this.item);

  markShoppingList(BuildContext context) {

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('${genLang['edit'][lang]} ${item.name}'),
            content: Wrap(
              children: <Widget>[EditForm(item)],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var required = item.amountBase - item.amountInStock;
    if (required < 0) {
      required = 0;
    }
    var totalPrice = required * item.pricePerUnit;

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Slidable(
        key: Key('${item.name}'),
        actionPane: SlidableScrollActionPane(),
        actionExtentRatio: 0.10,
        secondaryActions: <Widget>[
          IconSlideAction(
            icon: Icons.edit,
            color: Colors.blue,
            onTap: () {
              markShoppingList(context);
            },
          ),
          IconSlideAction(
            icon: Icons.add,
            color: Colors.green,
            onTap: () {
              item.amountInStock += 1;
              DatabaseProvider.db.update(item);
              BlocProvider.of<ItemBloc>(context).add(ItemEvent.update(item));
            },
          ),
          IconSlideAction(
            icon: Icons.remove,
            color: Colors.red,
            onTap: () {
              if (item.amountInStock > 0) {
                item.amountInStock -= 1;
                DatabaseProvider.db.update(item);
                BlocProvider.of<ItemBloc>(context).add(ItemEvent.update(item));
              }
            },
          ),
        ],
        actions: <Widget>[
          IconSlideAction(
            icon: Icons.edit,
            color: Colors.blue,
            onTap: () {
              markShoppingList(context);
            },
          ),
          IconSlideAction(
            icon: Icons.add,
            color: Colors.green,
            onTap: () {
              item.amountInStock += 1;
              DatabaseProvider.db.update(item);
              BlocProvider.of<ItemBloc>(context).add(ItemEvent.update(item));
            },
          ),
          IconSlideAction(
            icon: Icons.remove,
            color: Colors.red,
            onTap: () {
              if (item.amountInStock > 0) {
                item.amountInStock -= 1;
                DatabaseProvider.db.update(item);
                BlocProvider.of<ItemBloc>(context).add(ItemEvent.update(item));
              }
            },
          ),
        ],
        child: ExpansionTile(
          title: Row(
            children: <Widget>[
              Expanded(
                  child:
                      Text(item.name, textAlign: dirLang['tile_left'][lang])),
              Text('${item.amountInStock}',
                  textAlign: dirLang['tile_right'][lang]),
            ],
          ),
          children: <Widget>[
            Text('${expLang['base'][lang]} ${item.amountBase}'),
            Text(
                '${expLang['price1'][lang]} $required ${expLang['price2'][lang]} ${currency(totalPrice)}'),
          ],
        ),
      ),
    );
  }
}

class ShopExpansionTile extends StatelessWidget {
  final Item item;

  markShoppingList(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          customController.clear();
          return AlertDialog(
            title: Text(expLang['update'][lang]),
            content: TextField(
              decoration: InputDecoration(
                labelText: expLang['update_shop_question'][lang],
              ),
              controller: customController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text(genLang['submit'][lang]),
                onPressed: () {
                  Navigator.of(context)
                      .pop(int.tryParse(customController.text));
                },
              ),
              MaterialButton(
                child: Text(genLang['cancel'][lang]),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  ShopExpansionTile(this.item);

  @override
  Widget build(BuildContext context) {
    var required = item.amountBase - item.amountInStock;
    if (required < 0) {
      required = 0;
    }
    var totalPrice = required * item.pricePerUnit;
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Slidable(
        key: Key('${item.name}'),
        actionPane: SlidableScrollActionPane(),
        actionExtentRatio: 0.25,
        actions: <Widget>[
          IconSlideAction(
            caption: expLang['fill'][lang],
            icon: Icons.check,
            color: Colors.green,
            onTap: () {
              item.amountInStock = item.amountBase;
              DatabaseProvider.db.update(item);
              BlocProvider.of<ItemBloc>(context).add(ItemEvent.update(item));
            },
          ),
        ],
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: expLang['fill'][lang],
            icon: Icons.check,
            color: Colors.green,
            onTap: () {
              item.amountInStock = item.amountBase;
              DatabaseProvider.db.update(item);
              BlocProvider.of<ItemBloc>(context).add(ItemEvent.update(item));
            },
          ),
        ],
        child: ExpansionTile(
          leading: IconButton(
            icon: Icon(
              Icons.add,
              color: Colors.green,
            ),
            onPressed: () {
              markShoppingList(context).then((newStock) {
                if (newStock == null) {
                  newStock = 0;
                }
                item.amountInStock += newStock;
                DatabaseProvider.db.update(item);
                BlocProvider.of<ItemBloc>(context).add(ItemEvent.update(item));
              });
            },
          ),
          title: Row(
            children: <Widget>[
              Expanded(
                  child:
                      Text(item.name, textAlign: dirLang['tile_left'][lang])),
              Expanded(
                  child: Text('${expLang['need'][lang]} $required',
                      textAlign: dirLang['tile_right'][lang])),
            ],
          ),
          children: <Widget>[
            Text('${expLang['price_of'][lang]} ${currency(totalPrice)}')
          ],
        ),
      ),
    );
  }
}

class ReStockExpansionTile extends StatelessWidget {
  final Item item;

  markShoppingList(BuildContext context) {
    TextEditingController customController = TextEditingController();

    return showDialog(
        context: context,
        builder: (context) {
          customController.clear();
          return AlertDialog(
            title: Text(expLang['update'][lang]),
            content: TextField(
              decoration: InputDecoration(
                labelText: expLang['update_stock_question'][lang],
                helperText: expLang['update_stock_helper'][lang],
                helperMaxLines: 3,
              ),
              controller: customController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                WhitelistingTextInputFormatter.digitsOnly
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text(genLang['submit'][lang]),
                onPressed: () {
                  Navigator.of(context)
                      .pop(int.tryParse(customController.text));
                },
              ),
              MaterialButton(
                child: Text(genLang['cancel'][lang]),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  ReStockExpansionTile(this.item);

  @override
  Widget build(BuildContext context) {
    var required = item.amountBase - item.amountInStock;
    if (required < 0) {
      required = 0;
    }
    return ListTile(
      leading: IconButton(
        icon: Icon(
          Icons.remove,
          color: Colors.red,
        ),
        onPressed: () {
          markShoppingList(context).then((newStock) {
            if (newStock == null || newStock <= 0) {
              return;
            }
            if (newStock > item.amountInStock) {
              item.amountInStock = 0;
            } else {
              item.amountInStock -= newStock;
            }
            DatabaseProvider.db.update(item);
            BlocProvider.of<ItemBloc>(context).add(ItemEvent.update(item));
          });
        },
      ),
      title: Row(
        children: <Widget>[
          Expanded(
              child: Text(item.name, textAlign: dirLang['tile_left'][lang])),
          Expanded(
              child: Text('${expLang['stock'][lang]} ${item.amountInStock}',
                  textAlign: dirLang['tile_right'][lang])),
        ],
      ),
      onTap: () {},
      onLongPress: () {},
    );
  }
}
