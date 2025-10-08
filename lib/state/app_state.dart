class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  String selectedCity = 'Concordia';
  String selectedFlag = 'assets/flags/concordia.jpg';
}
