import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';

void main(){
  const forecastedWeatherResponse = """
{
  "cod": "200",
  "message": 0,
  "cnt": 40,
  "list": [
    {
      "dt": 1661871600,
      "main": {
        "temp": 296.76,
        "feels_like": 296.98,
        "temp_min": 296.76,
        "temp_max": 297.87,
        "pressure": 1015,
        "sea_level": 1015,
        "grnd_level": 933,
        "humidity": 69,
        "temp_kf": -1.11
      },
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "description": "light rain",
          "icon": "10d"
        }
      ],
      "clouds": {
        "all": 100
      },
      "wind": {
        "speed": 0.62,
        "deg": 349,
        "gust": 1.18
      },
      "visibility": 10000,
      "pop": 0.32,
      "rain": {
        "3h": 0.26
      },
      "sys": {
        "pod": "d"
      },
      "dt_txt": "2022-08-30 15:00:00"
    },
    {
      "dt": 1661882400,
      "main": {
        "temp": 295.45,
        "feels_like": 295.59,
        "temp_min": 292.84,
        "temp_max": 295.45,
        "pressure": 1015,
        "sea_level": 1015,
        "grnd_level": 931,
        "humidity": 71,
        "temp_kf": 2.61
      },
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "description": "light rain",
          "icon": "10n"
        }
      ],
      "clouds": {
        "all": 96
      },
      "wind": {
        "speed": 1.97,
        "deg": 157,
        "gust": 3.39
      },
      "visibility": 10000,
      "pop": 0.33,
      "rain": {
        "3h": 0.57
      },
      "sys": {
        "pod": "n"
      },
      "dt_txt": "2022-08-30 18:00:00"
    },
    {
      "dt": 1661893200,
      "main": {
        "temp": 292.46,
        "feels_like": 292.54,
        "temp_min": 290.31,
        "temp_max": 292.46,
        "pressure": 1015,
        "sea_level": 1015,
        "grnd_level": 931,
        "humidity": 80,
        "temp_kf": 2.15
      },
      "weather": [
        {
          "id": 500,
          "main": "Rain",
          "description": "light rain",
          "icon": "10n"
        }
      ],
      "clouds": {
        "all": 68
      },
      "wind": {
        "speed": 2.66,
        "deg": 210,
        "gust": 3.58
      },
      "visibility": 10000,
      "pop": 0.7,
      "rain": {
        "3h": 0.49
      },
      "sys": {
        "pod": "n"
      },
      "dt_txt": "2022-08-30 21:00:00"
    },
    {
      "dt": 1662292800,
      "main": {
        "temp": 294.93,
        "feels_like": 294.83,
        "temp_min": 294.93,
        "temp_max": 294.93,
        "pressure": 1018,
        "sea_level": 1018,
        "grnd_level": 935,
        "humidity": 64,
        "temp_kf": 0
      },
      "weather": [
        {
          "id": 804,
          "main": "Clouds",
          "description": "overcast clouds",
          "icon": "04d"
        }
      ],
      "clouds": {
        "all": 88
      },
      "wind": {
        "speed": 1.14,
        "deg": 17,
        "gust": 1.57
      },
      "visibility": 10000,
      "pop": 0,
      "sys": {
        "pod": "d"
      },
      "dt_txt": "2022-09-04 12:00:00"
    }
  ],
  "city": {
    "id": 3163858,
    "name": "Zocca",
    "coord": {
      "lat": 44.34,
      "lon": 10.99
    },
    "country": "IT",
    "population": 4593,
    "timezone": 7200,
    "sunrise": 1661834187,
    "sunset": 1661882248
  }
}""";     
Map<String,dynamic> mockedJson = jsonDecode(forecastedWeatherResponse) as Map<String,dynamic>;

List<WeatherData> weatherDataList = [];
WeatherData one = WeatherData(dtSunset: DateTime.fromMillisecondsSinceEpoch(1661882248*1000,isUtc:true), dtCurrent: DateTime.fromMillisecondsSinceEpoch(1661871600*1000,isUtc:true),temp: Temperature(defaultTemperature: 296.76), minTemp: Temperature(defaultTemperature: 296.76), maxTemp: Temperature(defaultTemperature: 297.87), 
  weatherInfo: {
      "id": 500,
      "main": "Rain",
      "description": "light rain",
      "icon": "10d"
    }, iconUrl: "https://openweathermap.org/img/wn/10d.png");

WeatherData two = WeatherData(dtSunset: DateTime.fromMillisecondsSinceEpoch(1661882248*1000,isUtc:true), dtCurrent: DateTime.fromMillisecondsSinceEpoch(1661882400*1000,isUtc:true),temp: Temperature(defaultTemperature: 295.45), minTemp: Temperature(defaultTemperature: 292.84), maxTemp: Temperature(defaultTemperature: 295.45), 
  weatherInfo: {
      "id": 500,
      "main": "Rain",
      "description": "light rain",
      "icon": "10n"
    }, iconUrl: "https://openweathermap.org/img/wn/10n.png");

WeatherData three = WeatherData(dtSunset: DateTime.fromMillisecondsSinceEpoch(1661882248*1000,isUtc:true), dtCurrent: DateTime.fromMillisecondsSinceEpoch(1661893200*1000,isUtc:true),temp: Temperature(defaultTemperature: 292.46), minTemp: Temperature(defaultTemperature: 290.31), maxTemp: Temperature(defaultTemperature: 292.46), 
  weatherInfo: {
      "id": 500,
      "main": "Rain",
      "description": "light rain",
      "icon": "10n"
    }, iconUrl: "https://openweathermap.org/img/wn/10n.png");

WeatherData four = WeatherData(dtSunset: DateTime.fromMillisecondsSinceEpoch(1661882248*1000,isUtc:true), dtCurrent: DateTime.fromMillisecondsSinceEpoch(1662292800*1000,isUtc:true),temp: Temperature(defaultTemperature: 294.93), minTemp: Temperature(defaultTemperature: 294.93), maxTemp: Temperature(defaultTemperature: 294.93), 
  weatherInfo: {
      "id": 804,
      "main": "Clouds",
      "description": "overcast clouds",
      "icon": "04d"
    }, iconUrl: "https://openweathermap.org/img/wn/04d.png");

weatherDataList.addAll([one,two,three,four]);

ForecastData matcher = ForecastData(forecast: weatherDataList);

test("Testing that the 3 hour interval Weather Data is correctly extracted and used to create the ForecastData Object", (){
ForecastData sut = ForecastData.fromJson(mockedJson);
assert(sut.forecast.length == matcher.forecast.length); //"Test and Mock Lists must be equal in length");
for (int i = 0; i<matcher.forecast.length; i++){
  expect(sut.forecast.elementAt(i).temp.defaultTemperature, matcher.forecast.elementAt(i).temp.defaultTemperature);
  expect(sut.forecast.elementAt(i).minTemp.celsius, matcher.forecast.elementAt(i).minTemp.celsius);
  expect(sut.forecast.elementAt(i).maxTemp.farenheight, matcher.forecast.elementAt(i).maxTemp.farenheight);
  expect(sut.forecast.elementAt(i).weatherInfo, matcher.forecast.elementAt(i).weatherInfo);
  expect(sut.forecast.elementAt(i).iconUrl, matcher.forecast.elementAt(i).iconUrl);

  expect(sut.forecast.elementAt(i).dtCurrent, matcher.forecast.elementAt(i).dtCurrent);
  expect(sut.forecast.elementAt(i).dtSunset, matcher.forecast.elementAt(i).dtSunset);
  

}}
    

);
  
  
  
  
}



