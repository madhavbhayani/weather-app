class ForecastModel {
  final DateTime date;
  final double temp;
  final String condition;
  final String icon;

  ForecastModel({
    required this.date,
    required this.temp,
    required this.condition,
    required this.icon,
  });

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    return ForecastModel(
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temp: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
    );
  }
}
