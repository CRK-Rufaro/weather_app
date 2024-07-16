import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';



void main(){
  const encodedWeatherJsonResponse = """
{
  "coord": {
    "lon": -122.08,
    "lat": 37.39
  },
  "weather": [
    {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }
  ],
  "base": "stations",
  "main": {
    "temp": 282.55,
    "feels_like": 281.86,
    "temp_min": 280.37,
    "temp_max": 284.26,
    "pressure": 1023,
    "humidity": 100
  },
  "visibility": 16093,
  "wind": {
    "speed": 1.5,
    "deg": 350
  },
  "clouds": {
    "all": 1
  },
  "dt": 1560350645,
  "sys": {
    "type": 1,
    "id": 5122,
    "message": 0.0139,
    "country": "US",
    "sunrise": 1560343627,
    "sunset": 1560396563
  },
  "timezone": -25200,
  "id": 420006353,
  "name": "Mountain View",
  "cod": 200
  }  
""";


  Map<String,dynamic> mockedJson = jsonDecode(encodedWeatherJsonResponse) as Map<String,dynamic>;

  WeatherData matcher = WeatherData(temp: Temperature(defaultTemperature: 282.55), minTemp: Temperature(defaultTemperature: 280.37), maxTemp: Temperature(defaultTemperature: 284.26), 
  weatherInfo: {
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }, iconUrl: "https://openweathermap.org/img/wn/01d.png");

    test("Testing that WeatherData Class correctly extracts data from JSON parameter", (){
      //print("testing WeatherData Class");
        WeatherData sut = WeatherData.fromJson(mockedJson);
      // print(sut.temp.defaultTemperature);
      // print(sut.minTemp.celsius);
      // print(sut.maxTemp.farenheight);
      // print(sut.weatherInfo);
      // print(sut.iconUrl);
      
        expect(sut.temp.defaultTemperature, matcher.temp.defaultTemperature);
        expect(sut.minTemp.celsius, matcher.minTemp.celsius);
        expect(sut.maxTemp.farenheight, matcher.maxTemp.farenheight);
        expect(sut.weatherInfo, matcher.weatherInfo);
        expect(sut.iconUrl, matcher.iconUrl);
    });
}