import 'package:flutter_bloc/flutter_bloc.dart';

import '../assets/objectClasses/item.dart';
import '../assets/objectClasses/settings_class.dart';

class OrganizerBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (transition.currentState is Item){
      print(transition.currentState);
      print(transition.nextState);
    }
    else if (transition.currentState is Settings){
      print('lang = ${transition.currentState.language}, cur = ${transition.currentState.currency}, theme = ${transition.currentState.theme}');
      print('lang = ${transition.nextState.language}, cur = ${transition.nextState.currency}, theme = ${transition.nextState.theme}');
    }

  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    print(error);
  }
}
