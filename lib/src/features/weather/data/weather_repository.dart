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

  getWeather({required String city}) async{
    print("calling get weather");
    //Pseudo auto_Geo_Locating
    final cityResponse = await getCity(city: city); //To return city not found exception
    print("city is located");
    print(cityResponse.name);
    print("retrieving weather data");
   final response = await client.get(api.weather(cityResponse));
   print(response.body);

   if(response.statusCode == 200){
    return WeatherData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
   }else{
    throw CustomException('Failed to retrieve weather data');
   }
  }

  getForecast({required String city}) async{
        //Pseudo auto_Geo_Locating
    final cityResponse = await getCity(city: city);
    final response = await client.get(api.forecast(cityResponse));

    if(response.statusCode == 200){
    //success
    return ForecastData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
   }else{
    throw CustomException('Failed to retrieve forecast data');
   }
  }

   Future<CityData> getCity({required String city}) async{
    print("calling geolocator");
    final response = await client.get(geoApi.directGeocoding(city));
    
    
    if(response.statusCode == 200){
    //success
    //jsonArray is passed into jsonDecode List<dynamic> is returned
    List<dynamic> dataList = jsonDecode(response.body);
    List<Map<String,dynamic>> newList = [];
    newList =  (dataList.map((subMap)=>subMap as Map<String,dynamic>)).toList();
    
    return CityData.fromJson( newList 
    //as List<Map<String,dynamic>>
    );
   }else{
    print("error");
    throw CityNotFoundException();
   }


  }

  
}
