import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/geocoding_api.dart';
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

    //Pseudo auto_Geo_Locating
    //print("calling get weather");
    //Pseudo auto_Geo_Locating
    final cityResponse = await getCity(city: city); //To return city not found exception
    // print("city is located");
    // print(cityResponse.name);
    // print("retrieving weather data");
   final response = await client.get(api.weather(cityResponse));
   //print(response.body);
      if(response.statusCode!=403 && response.statusCode!=401){
        if(response.statusCode!=404){
          if(response.statusCode == 200){
            //success
            return WeatherData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
          }
          //Connection confirmed, Api Valid, Fails with some other error
          throw UnknownException();
        }
        ///Api returns 400 bad request with invalid parsed in data
        throw UnknownException(); //Supposed to be a custom  resource not found exception
      }
      throw InvalidApiKeyException();
    }


  getForecast({required String city}) async{

        //Pseudo auto_Geo_Locating
    final cityResponse = await getCity(city: city);
    final response = await client.get(api.forecast(cityResponse));
      if(response.statusCode!=403&& response.statusCode!=401){
        if(response.statusCode!=404){
          if(response.statusCode == 200){
            //success
            return ForecastData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
          }
          //Connection confirmed, Api Valid, Fails with some other error
          throw UnknownException();
        }
        ///Api returns 400 bad request with invalid parsed in data
        throw UnknownException(); //Supposed to be a custom  resource not found exception
      }
      throw InvalidApiKeyException();
    }

   Future<CityData> getCity({required String city}) async{

    //print("calling geolocator");
    final response = await client.get(geoApi.directGeocoding(city));  

      if(response.statusCode!=403&&response.statusCode!=401){
        if(response.statusCode!=404){
          if(response.statusCode == 200){
          //success
          List<dynamic> dataList = jsonDecode(response.body); //jsonArray passed into jsonDecode -> List<dynamic> is returned
          if(dataList.isEmpty){
            //Connection confirmed, Api Valid but there is no result in response
            throw CityNotFoundException();
          }
          List<Map<String,dynamic>> newList = [];
          newList =  (dataList.map((subMap)=>subMap as Map<String,dynamic>)).toList();
          return CityData.fromJson(newList);
         }
         //Connection confirmed, Api Valid, Fails with some other error
          throw UnknownException();  
        }
        throw CityNotFoundException();             
      }
      throw InvalidApiKeyException();
  }
  
  
}
