import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/api/geocoding_api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/city_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  HttpWeatherRepository repository = HttpWeatherRepository(
    api: OpenWeatherMapAPI(sl<String>(instanceName: 'api_key')),
    client: http.Client(),
    geoApi: GeocodingAPI(sl<String>(instanceName: 'api_key'))
  );

  // initState()async {
  //   currentCityData = await repository.getCity(city: city);
  // }

  String city = 'London'; 

  //// edited directly from search box
  //CityData? currentCityData;


  
  
  
  

  WeatherData? currentWeatherProvider;
  ForecastData? hourlyWeatherProvider;

  bool isLoading =  false;

  

  // Future<void> getCityData() async{
  //   final cityData = await repository.getCity(city: city);
  //   currentCityData = cityData;
  // }

  Future<void> getWeatherData() async {
    isLoading = true;
    notifyListeners();

    //getCityData();//updating city variable

    final weather = await repository.getWeather(city: city);
    //TODO set the weather and fetch forecast after
    currentWeatherProvider = weather;
    getForecastData();

  }

  Future<void> getForecastData() async {
    final forecast = await repository.getForecast(city: city);
    //TODO set the forecast
    hourlyWeatherProvider = forecast;
    
    isLoading = false;
    notifyListeners();
  }
}




