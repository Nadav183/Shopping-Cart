import '../assets/objectClasses/settings_class.dart';

enum EventType { update, reset, get}

class SettingsEvent {
  Settings settings;
  EventType eventType;

  SettingsEvent.update(Settings settings) {
    this.eventType = EventType.update;
    this.settings = settings;
  }

  SettingsEvent.reset() {
    this.eventType = EventType.reset;
  }
}
