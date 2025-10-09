class AppState {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  String selectedCity = 'Concórdia';
  String selectedFlag = 'assets/flags/concordia.jpg';

  double? cityLat;
  double? cityLon;
}