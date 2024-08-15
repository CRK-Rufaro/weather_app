import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';

class ForecastData {
  final List<WeatherData> forecast;

  ForecastData({required this.forecast});

  factory ForecastData.fromJson (Map<String,dynamic> json){

      double safeConvert(dynamic value) {
        if (value is int) {
          return value.toDouble();
        } else if (value is double) {
          return value;
        } else {
          throw Exception('Unexpected type for value: $value');
        }
      }

  final sunsetTime = json["city"]["sunset"];
  List<WeatherData> retrievedforecastdata = (json["list"] as List).map((timeStep)=> //3 hour intervals
  WeatherData(
    dtCurrent: DateTime.fromMillisecondsSinceEpoch(timeStep["dt"]*1000,isUtc: true) ,
    dtSunset:  DateTime.fromMillisecondsSinceEpoch(sunsetTime*1000,isUtc:true),
    temp: Temperature(defaultTemperature:safeConvert(timeStep["main"]["temp"]) ),
    minTemp: Temperature(defaultTemperature:safeConvert(timeStep["main"]["temp_min"]) ),
    maxTemp: Temperature(defaultTemperature:safeConvert(timeStep["main"]["temp_max"]) ),
    weatherInfo: timeStep["weather"][0],
    iconUrl: "https://openweathermap.org/img/wn/${timeStep["weather"][0]["icon"]}.png",
  )
  ).toList();

  return ForecastData(forecast: retrievedforecastdata);
  }


}