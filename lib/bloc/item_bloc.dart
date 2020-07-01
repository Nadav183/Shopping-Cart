import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/events/item_event.dart';

class ItemBloc extends Bloc<ItemEvent, List<Item>> {
  @override
  List<Item> get initialState => List<Item>();

  @override
  Stream<List<Item>> mapEventToState(ItemEvent event) async* {
    switch (event.eventType) {
      case EventType.insert:
        List<Item> newState = List.from(state);
        if (event.item != null) {
          newState.add(event.item);
        }
        yield newState;
        break;
      case EventType.delete:
        List<Item> newState = List.from(state);
        newState.remove(event.item);
        yield newState;
        break;
      case EventType.setItems:
        List<Item> newState = List.from(state);
        newState = event.itemList;
        yield newState;
        break;
      case EventType.update:
        List<Item> newState = List.from(state);
        newState[newState.indexWhere((item) => item.id == event.item.id)] =
            event.item;
        yield newState;
        break;
      case EventType.reorder:
        List<Item> newState = List.from(state);
        var tempItem = newState[event.oldIndex];
        newState.removeAt(event.oldIndex);
        if (event.oldIndex < event.newIndex) {
          newState.insert(event.newIndex - 1, tempItem);
        } else {
          newState.insert(event.newIndex, tempItem);
        }
        yield newState;
        break;
      default:
        throw Exception('Unsupported event: $event');
        break;
    }
  }
}
