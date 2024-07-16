import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:http/http.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/geocoding_api.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/city_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';

class HttpWeatherRepository{
  final OpenWeatherMapAPI api;
  final Client client;
  final GeocodingAPI geoApi;

  HttpWeatherRepository({required this.api, required this.client, required this.geoApi});

  getWeather({required CityData city}) async{
    //Pseudo autogeolocating
   final response = await client.get(api.weather(city));

   if(response.statusCode == 200){
    return WeatherData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
   }else{
    throw CustomException('Failed to retrieve weather data');
   }
  }

  getForecast({required CityData city}) async{
    final response = await client.get(api.forecast(city));

    if(response.statusCode == 200){
    //success
    return ForecastData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
   }else{
    throw CustomException('Failed to retrieve forecast data');
   }
  }

   Future<CityData> getCity({required String city}) async{
    final response = await client.get(geoApi.directGeocoding(city));
    
    if(response.statusCode == 200){
    //success
    return CityData.fromJson(jsonDecode(response.body)as List<Map<String,dynamic>>);
   }else{
    throw CityNotFoundException();
   }


  }

  
}
