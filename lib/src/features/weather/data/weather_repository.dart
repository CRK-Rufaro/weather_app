import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';

class HttpWeatherRepository{
  final OpenWeatherMapAPI api;
  final Client client;

  HttpWeatherRepository({required this.api, required this.client});

  getWeather({required String city}) async{
   final response = await client.get(api.weather(city));

   if(response.statusCode == 200){
    return WeatherData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
   }else{
    throw Exception('Failed to retrieve weather data');
   }
  }
  
  // Future<WeatherData> getWeather({required String city}) async {
  //   final response = await client.get(api.weatherUrl(city: city));

  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(response.body);
  //     return WeatherData.fromJson(json);
  //   } else {
  //     throw Exception('Failed to load weather data');
  //   }
  // }

  getForecast({required String city}) async{
    final response = await client.get(api.forecast(city));

    if(response.statusCode == 200){
    //success
    return ForecastData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
   }else{
    throw Exception('Failed to retrieve forecast data');
   }
  }

  
}
