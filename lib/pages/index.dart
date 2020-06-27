import 'package:flutter/material.dart';
import '../db/database.dart';

class Index extends StatelessWidget {
  final items = [];
  Future<void> collect() async {
    var list = await DatabaseProvider.db.getItems();
    list.forEach((item) {
      if (item.name != null){
        items.add(item);
      }
    });
  }

  Widget build(BuildContext context) {
    collect();
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
            ...((items).map((item) {
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