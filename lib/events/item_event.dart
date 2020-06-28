

import 'package:organizer/assets/item.dart';

enum EventType{insert, delete, setItems}

class ItemEvent {
  List<Item> itemList;
  Item item;
  int itemIndex;
  EventType eventType;

  ItemEvent.insert(Item item){
    this.eventType = EventType.insert;
    this.item = item;
  }
  ItemEvent.delete(Item item){
    this.eventType = EventType.delete;
    this.itemIndex = item.id;
  }
  ItemEvent.setItems(List<Item> itemList){
    this.eventType = EventType.setItems;
    this.itemList = itemList;
  }
}