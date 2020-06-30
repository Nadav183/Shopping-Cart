
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/db/database.dart';
import 'package:organizer/events/item_event.dart';
import 'package:organizer/style/designStyle.dart';

import 'editForm.dart';

class IndexExpansionTile extends StatelessWidget {
  final Item item;
  
  IndexExpansionTile(this.item);

  deleteConfirmationDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text('Delete ${item.name}'),
        content: Text(
            'Are you sure you want to delete the item \'${item.name}\' from your inventory?',
          maxLines: 5,
          softWrap: true,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              DatabaseProvider.db.remove(item.id);
              BlocProvider.of<ItemBloc>(context).add(
                ItemEvent.delete(item)
              );
              Navigator.pop(context);
            },
          ),
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  markShoppingList(BuildContext context){
    TextEditingController customController = TextEditingController();

    return showDialog(context: context, builder: (context){
      customController.clear();
      return AlertDialog(
        title: Text('Edit ${item.name}'),
        content: Wrap(
          children: <Widget>[EditForm(item)],
        ),
      );
    });
  }
  
  @override
  Widget build(BuildContext context) {

    var required = item.amountBase-item.amountInStock;
    if (required<0) {required = 0;}
    var totalPrice = required*item.pricePerUnit;
    return ExpansionTile(
      leading: IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          markShoppingList(context);
        },
      ),
      title: Row(
        children: <Widget>[
          Expanded(child:Text(item.name, textAlign: TextAlign.left)),
          Expanded(child:Text('${ils.format(item.pricePerUnit)}',textAlign: TextAlign.center)),
          Expanded(child:Text('${item.amountInStock}',textAlign: TextAlign.right)),
        ],
      ),
      children: <Widget>[
        Text('Base Amount: ${item.amountBase}'),
        Text('Need to buy $required for ${ils.format(totalPrice)}'),
        FlatButton(
          child: Row(children: <Widget>[Icon(Icons.clear,color: Colors.red,),Text('delete this item')]),
          onPressed: () {deleteConfirmationDialog(context);},
        )
      ],
    );
  }
}

class ShopExpansionTile extends StatelessWidget {
  final Item item;

  markShoppingList(BuildContext context){
    TextEditingController customController = TextEditingController();

    String controllerValidation(TextEditingController value){
      if (value.text.length<3 && value.text.isNotEmpty){
        return'length';
      }
      if ((!RegExp(r'^[+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$').hasMatch(value.text)) && value.text.isNotEmpty){
        return'Please enter a positive whole number';
      }
      return null;
    }

    return showDialog(context: context, builder: (context){
      customController.clear();
      return AlertDialog(
        title: Text('Update List'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'How many did you get?',
            errorText: controllerValidation(customController),
          ),
          controller: customController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text('Submit'),
            onPressed: () {
              Navigator.of(context).pop(int.tryParse(customController.text));
            },
          ),
          MaterialButton(
            child: Text('Cancel'),
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
    var required = item.amountBase-item.amountInStock;
    if (required<0) {required = 0;}
    var totalPrice = required*item.pricePerUnit;
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.add, color: Colors.green,),
        onPressed: () {
          markShoppingList(context).then((newStock) {
            if (newStock == null){newStock = 0;}
            item.amountInStock += newStock;
            DatabaseProvider.db.update(item);
            BlocProvider.of<ItemBloc>(context).add(
                ItemEvent.update(item)
            );
          });
        },
      ),
      title: Row(
        children: <Widget>[
          Expanded(child:Text(item.name, textAlign: TextAlign.left)),
          Expanded(child:Text('Need: $required',textAlign: TextAlign.left)),
          Expanded(child:Text(ils.format(totalPrice),textAlign: TextAlign.center)),
        ],
      ),
      onTap: () {},
      onLongPress: () {},
    );
  }
}

class ReStockExpansionTile extends StatelessWidget {
  final Item item;

  markShoppingList(BuildContext context){
    TextEditingController customController = TextEditingController();

    String controllerValidation(TextEditingController value){
      if (value.text.length<3 && value.text.isNotEmpty){
        return'length';
      }
      if ((!RegExp(r'^[+]?([0-9]+([.][0-9]*)?|[.][0-9]+)$').hasMatch(value.text)) && value.text.isNotEmpty){
        return'Please enter a positive whole number';
      }
      return null;
    }

    return showDialog(context: context, builder: (context){
      customController.clear();
      return AlertDialog(
        title: Text('Update List'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'How many did you use?',
            errorText: controllerValidation(customController),
            helperText: 'entering a number larger than your stock will empty stock',
            helperMaxLines: 3,
          ),
          controller: customController,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[WhitelistingTextInputFormatter.digitsOnly],
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text('Submit'),
            onPressed: () {
              Navigator.of(context).pop(int.tryParse(customController.text));
            },
          ),
          MaterialButton(
            child: Text('Cancel'),
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
    var required = item.amountBase-item.amountInStock;
    if (required<0) {required = 0;}
    return ListTile(
      leading: IconButton(
        icon: Icon(Icons.remove, color: Colors.red,),
        onPressed: () {
        markShoppingList(context).then((newStock) {
          if (newStock == null || newStock <= 0){
            return;
          }
          if (newStock > item.amountInStock){
            item.amountInStock = 0;
          }
          else {
            item.amountInStock -= newStock;
          }
          DatabaseProvider.db.update(item);
          BlocProvider.of<ItemBloc>(context).add(
              ItemEvent.update(item)
          );
        });
      },
      ),
      title: Row(
        children: <Widget>[
          Expanded(child:Text(item.name, textAlign: TextAlign.left)),
          Expanded(child:Text('In Stock: ${item.amountInStock}',textAlign: TextAlign.right)),
        ],
      ),
      onTap: () {},
      onLongPress: () {},
    );
  }
}