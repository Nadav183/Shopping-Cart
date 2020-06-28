
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/item.dart';
import 'package:intl/intl.dart';
import 'package:organizer/bloc/item_bloc.dart';
import 'package:organizer/db/database.dart';
import 'package:organizer/events/item_event.dart';

class IndexExpansionTile extends StatelessWidget {
  final Item item;
  
  IndexExpansionTile(this.item);
  
  @override
  Widget build(BuildContext context) {
    var ilsFormat = NumberFormat.simpleCurrency(name:'ILS');
    var required = item.amountBase-item.amountInStock;
    if (required<0) {required = 0;}
    var totalPrice = required*item.pricePerUnit;
    return ExpansionTile(
      title: Row(
        children: <Widget>[
          Expanded(child:Text(item.name, textAlign: TextAlign.left)),
          Expanded(child:Text('${ilsFormat.format(item.pricePerUnit)}',textAlign: TextAlign.center)),
          Expanded(child:Text('${item.amountInStock}',textAlign: TextAlign.right)),
        ],
      ),
      children: <Widget>[
        Text('Base Amount: ${item.amountBase}'),
        Text('Need to buy $required for $totalPrice NIS'),
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
      return AlertDialog(
        title: Text('Update List'),
        content: TextField(
          decoration: InputDecoration(
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
    var ilsFormat = NumberFormat.simpleCurrency(name:'ILS');
    var required = item.amountBase-item.amountInStock;
    if (required<0) {required = 0;}
    var totalPrice = required*item.pricePerUnit;
    return ListTile(
      title: Row(
        children: <Widget>[
          Expanded(child:Text(item.name, textAlign: TextAlign.left)),
          Expanded(child:Text('Need: $required',textAlign: TextAlign.right)),
          Expanded(child:Text('for ${ilsFormat.format(totalPrice)}',textAlign: TextAlign.center)),
        ],
      ),
      onTap: () {
        markShoppingList(context).then((newStock) {
          if (newStock == null){newStock = 0;}
          item.amountInStock += newStock;
          DatabaseProvider.db.update(item);
          BlocProvider.of<ItemBloc>(context).add(
            ItemEvent.update(item)
          );
        });
      },
    );
  }
}