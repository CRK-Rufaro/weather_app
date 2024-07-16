import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';

class ForecastData {
  final List<WeatherData> forecast;

  ForecastData({required this.forecast});

  factory ForecastData.fromJson (Map<String,dynamic> json){
    // double currTime = json["list"]["dt"];
    // double sunsetTime = json["list"]["sunset"];
    //print(json["list"] as List);
  List<WeatherData> retrievedforecastdata = (json["list"] as List).map((timeStep)=> //3 hour intervals
  WeatherData(
    temp: Temperature(defaultTemperature: timeStep["main"]["temp"]),
    minTemp: Temperature(defaultTemperature:timeStep["main"]["temp_min"]),
    maxTemp: Temperature(defaultTemperature:timeStep["main"]["temp_max"]),
    weatherInfo: timeStep["weather"][0],
    iconUrl: "https://openweathermap.org/img/wn/${timeStep["weather"][0]["icon"]}.png",
  )
  ).toList();

  return ForecastData(forecast: retrievedforecastdata);
  }
}