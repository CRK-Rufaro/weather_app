import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';

class ForecastData {
  final List<WeatherData> forecast;

  ForecastData({required this.forecast});

  factory ForecastData.fromJson (Map<String,dynamic> json){
    // double currTime = json["list"]["dt"];
    // double sunsetTime = json["list"]["sunset"];
  List<WeatherData> retrievedforecastdata = (json["list"] as List).map((day)=>
  WeatherData(
    temp: Temperature(defaultTemperature: day["temp"]["day"]),
    minTemp: Temperature(defaultTemperature:day["temp"]["min"]),
    maxTemp: Temperature(defaultTemperature:day["temp"]["max"]),
    weatherInfo: day["weather"],
    iconUrl: "https://openweathermap.org/img/wn/${day["weather"]["icon"]}.png",
  )
  ).toList();

  return ForecastData(forecast: retrievedforecastdata);
  }
}