import 'package:organizer/assets/item.dart';

enum EventType { insert, delete, setItems, update, reorder }

class ItemEvent {
  List<Item> itemList;
  Item item;
  int itemIndex;
  EventType eventType;
  int oldIndex;
  int newIndex;

  ItemEvent.insert(Item item) {
    this.eventType = EventType.insert;
    this.item = item;
  }

  ItemEvent.delete(Item item) {
    this.eventType = EventType.delete;
    this.item = item;
  }

  ItemEvent.setItems(List<Item> itemList) {
    this.eventType = EventType.setItems;
    this.itemList = itemList;
  }

  ItemEvent.update(Item item) {
    this.eventType = EventType.update;
    this.item = item;
  }

  ItemEvent.reorder(this.oldIndex, this.newIndex) {
    this.eventType = EventType.reorder;
  }
}
