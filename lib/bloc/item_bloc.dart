

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:organizer/assets/item.dart';
import 'package:organizer/events/item_event.dart';

class ItemBloc extends Bloc<ItemEvent, List<Item>>{
  @override
  // TODO: implement initialState
  List<Item> get initialState => List<Item>();

  @override
  Stream<List<Item>> mapEventToState(ItemEvent event) async*{
    switch(event.eventType){
      case EventType.insert:
        List<Item> newState = List.from(state);
        if (event.item != null){
          newState.add(event.item);
        }
        yield newState;
        break;
      case EventType.delete:
        List<Item> newState = List.from(state);
        newState.removeWhere((listItem) => listItem.id == event.item.id);
        yield newState;
        break;
      case EventType.setItems:
        List<Item> newState = List.from(state);
        newState = event.itemList;
        yield newState;
        break;
      default:
        throw Exception('Unsupported event: $event');
        break;
    }
  }
  
}