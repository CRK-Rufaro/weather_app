import 'package:flutter/foundation.dart';

class CityData{
  final String name;
  final double latitude;
  final double longitude;
  final String country;

  CityData({required this.name, required this.latitude, required this.longitude, required this.country});

  factory CityData.fromJson(List<Map<String,dynamic>> json){
    if (kDebugMode) {
      print(json[0]["name"]);
      print(json[0]["lat"]);
    }
    
    return CityData(name: json[0]["name"], latitude: json[0]["lat"], longitude: json[0]["lon"], country: json[0]["country"]);
  }
}