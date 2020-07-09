import 'package:flutter_bloc/flutter_bloc.dart';

import '../../assets/objectClasses/settings_class.dart';
import '../../events/settings_event.dart';

class SettingsBloc extends Bloc<SettingsEvent, Settings> {

  @override
  Settings get initialState {
    return Settings();
  }

  @override
  Stream<Settings> mapEventToState(SettingsEvent event) async* {
    switch (event.eventType) {
      case EventType.update:
        Settings newState = event.settings;
        yield newState;
        break;
      case EventType.reset:
        Settings newState = Settings();
        yield newState;
        break;
      default:
        throw Exception('Unsupported event: $event');
        break;
    }
  }
}
