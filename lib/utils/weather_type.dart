enum WeatherType {
  sunny,
  cloudy,
  rainy,
  snowy;

  static WeatherType fromString(String condition) {
    switch (condition.toLowerCase()) {
      case 'rain':
      case 'drizzle':
      case 'thunderstorm':
        return WeatherType.rainy;
      case 'snow':
        return WeatherType.snowy;
      case 'clouds':
        return WeatherType.cloudy;
      case 'clear':
      default:
        return WeatherType.sunny;
    }
  }
}
