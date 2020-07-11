import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../objectClasses/item.dart';
import '../../style/designStyle.dart';
import '../../style/lang.dart';
import 'editForm.dart';

class IndexExpansionTile extends StatelessWidget {
  final Item item;

  IndexExpansionTile(this.item);

  markBought(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          customController.clear();
          return AlertDialog(
            title: Text(expLang['bought'][lang]),
            content: TextField(
              decoration: InputDecoration(
                labelText: expLang['bought_question'][lang],
              ),
              controller: customController,
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text(genLang['submit'][lang]),
                onPressed: () {
                  Navigator.of(context)
                      .pop(double.tryParse(customController.text));
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

  markUsed(BuildContext context) {
    TextEditingController customController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          customController.clear();
          return AlertDialog(
            title: Text(expLang['used'][lang]),
            content: TextField(
              decoration: InputDecoration(
                labelText: expLang['used_question'][lang],
              ),
              controller: customController,
              keyboardType: TextInputType.number,
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text(genLang['submit'][lang]),
                onPressed: () {
                  Navigator.of(context)
                      .pop(double.tryParse(customController.text));
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
              markBought(context).then((newStock) {
                if (newStock == null) {
                  newStock = 0;
                }
                item.amountInStock += newStock;
                item.updateInDB(context);
              });
            },
          ),
          IconSlideAction(
            icon: Icons.remove,
            color: Colors.red,
            onTap: () {
              markUsed(context).then((used) {
                if (used == null) {
                  used = 0;
                }
                if (used > item.amountInStock){
                  used = item.amountInStock;
                }
                item.amountInStock -= used;
                item.updateInDB(context);
              });
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
              markBought(context).then((newStock) {
                if (newStock == null) {
                  newStock = 0;
                }
                item.amountInStock += newStock;
                item.updateInDB(context);
              });
            },
          ),
          IconSlideAction(
            icon: Icons.remove,
            color: Colors.red,
            onTap: () {
              markUsed(context).then((used) {
                if (used == null) {
                  used = 0;
                }
                if (used > item.amountInStock){
                  used = item.amountInStock;
                }
                item.amountInStock -= used;
                item.updateInDB(context);
              });
            },
          ),
        ],
        child: ExpansionTile(
          title: Row(
            children: <Widget>[
              Expanded(
                  child:
                      Text(item.name, textAlign: dirLang['tile_left'][lang])),
              Text('${item.amountInStock.toStringAsFixed(2)}',
                  textAlign: dirLang['tile_right'][lang]),
            ],
          ),
          children: <Widget>[
            Text('${expLang['base'][lang]} ${item.amountBase}'),
            Text(
                '${expLang['price1'][lang]} ${required.toStringAsFixed(2)} ${expLang['price2'][lang]} ${currency(totalPrice)}'),
            Text('Category = ${item.categoryName}'),
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
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text(genLang['submit'][lang]),
                onPressed: () {
                  Navigator.of(context)
                      .pop(double.tryParse(customController.text));
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
              item.updateInDB(context);
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
              item.updateInDB(context);
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
                item.updateInDB(context);
              });
            },
          ),
          title: Row(
            children: <Widget>[
              Expanded(
                  child:
                      Text(item.name, textAlign: dirLang['tile_left'][lang])),
              Expanded(
                  child: Text('${expLang['need'][lang]} ${required.toStringAsFixed(2)}',
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
            item.updateInDB(context);
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
