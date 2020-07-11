class Settings {
  String language;
  String currency;
  String theme;
  bool showUnCategorized;

  Settings({
    this.currency = 'ILS',
    this.language = 'HE',
    this.theme = 'default',
    this.showUnCategorized = false,
  });
}
