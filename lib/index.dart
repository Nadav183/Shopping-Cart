import 'package:flutter/material.dart';
import './item.dart';
var items = [Item(name: 'Onion', pricePerUnit: 1.3,amountInStock: 0,amountBase: 5),
             Item(name: 'Tomato', pricePerUnit: 2.3,amountInStock: 0,amountBase: 8),
             Item(name: 'Ground Beef Kilo', pricePerUnit: 32,amountInStock: 0,amountBase: 2),];

class Index extends StatelessWidget {

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Expanded(child: Row(
            children: <Widget>[
              Expanded(child:Text('Item Name', textAlign: TextAlign.left)),
              Expanded(child:Text('Price Per Unit',textAlign: TextAlign.center)),
              Expanded(child:Text('Stock/Required',textAlign: TextAlign.right)),
            ],
          )),
          ...(items.map((item) {
            return Expanded(child: Row(
              children: <Widget>[
                Expanded(child:Text('${item.name}', textAlign: TextAlign.left)),
                Expanded(child:Text('${item.pricePerUnit}',textAlign: TextAlign.center)),
                Expanded(child:Text('${item.amountInStock}/${item.amountBase}',textAlign: TextAlign.right)),
              ],
            ));
          }))
        ],
      ),
    );
  }
}