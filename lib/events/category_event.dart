import 'package:organizer/assets/category_class.dart';

enum EventType { insert, delete, setItems, update, reorder }

class CategoryEvent {
  List<Category> categoryList;
  Category category;
  int categoryIndex;
  EventType eventType;
  int oldIndex;
  int newIndex;

  CategoryEvent.insert(Category category) {
    this.eventType = EventType.insert;
    this.category = category;
  }

  CategoryEvent.delete(Category category) {
    this.eventType = EventType.delete;
    this.category = category;
  }

  CategoryEvent.setItems(List<Category> categoryList) {
    this.eventType = EventType.setItems;
    this.categoryList = categoryList;
  }

  CategoryEvent.update(Category category) {
    this.eventType = EventType.update;
    this.category = category;
  }

  CategoryEvent.reorder(this.oldIndex, this.newIndex) {
    this.eventType = EventType.reorder;
  }
}
