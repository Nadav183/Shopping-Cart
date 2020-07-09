import 'package:flutter_bloc/flutter_bloc.dart';

import '../../assets/category_class.dart';
import '../../events/category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, List<Category>> {
  @override
  List<Category> get initialState => List<Category>();

  @override
  Stream<List<Category>> mapEventToState(CategoryEvent event) async* {
    switch (event.eventType) {
      case EventType.insert:
        List<Category> newState = List.from(state);
        if (event.category != null) {
          newState.add(event.category);
        }
        yield newState;
        break;
      case EventType.delete:
        List<Category> newState = List.from(state);
        newState.remove(event.category);
        yield newState;
        break;
      case EventType.setItems:
        List<Category> newState = event.categoryList;
        yield newState;
        break;
      case EventType.update:
        List<Category> newState = List.from(state);
        newState[newState.indexWhere((category) => category.id == event.category.id)] =
            event.category;
        yield newState;
        break;
      case EventType.reorder:
        List<Category> newState = List.from(state);
        var tempCategory = newState[event.oldIndex];
        newState.removeAt(event.oldIndex);
        if (event.oldIndex < event.newIndex) {
          newState.insert(event.newIndex - 1, tempCategory);
        } else {
          newState.insert(event.newIndex, tempCategory);
        }
        yield newState;
        break;
      default:
        throw Exception('Unsupported event: $event');
        break;
    }
  }
}
