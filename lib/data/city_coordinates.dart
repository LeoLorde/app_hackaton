class CityCoordinates {
  static final Map<String, Map<String, double>> cities = {
    'Concórdia': {'lat': -27.2339, 'lon': -52.0278},
    'Seara': {'lat': -27.1568, 'lon': -52.2998},
    'Ipumirim': {'lat': -27.0831, 'lon': -52.1319},
    'Arabutã': {'lat': -27.1581, 'lon': -52.1422},
    'Irani': {'lat': -27.0222, 'lon': -51.9014},
    'Xanxerê': {'lat': -26.8756, 'lon': -52.4043},
    'Chapecó': {'lat': -27.1000, 'lon': -52.6167},
  };

  static Map<String, double> getCoordinates(String cityName) {
    return cities[cityName] ?? {'lat': -27.2339, 'lon': -52.0278}; // default Concórdia
  }
}