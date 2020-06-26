import 'package:flutter/material.dart';
import '../assets/item.dart';
var items = [Item(name: 'Onion', pricePerUnit: 1.3,amountInStock: 0,amountBase: 5),
             Item(name: 'Tomato', pricePerUnit: 2.3,amountInStock: 0,amountBase: 8),
             Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),
  Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),
  Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),
  Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),
  Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),
  Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),
  Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),
  Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),
  Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),
  Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),];

class Index extends StatelessWidget {

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
            ...(items.map((item) {
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
            }))
          ],))
        ],
      ),
    );
  }
}