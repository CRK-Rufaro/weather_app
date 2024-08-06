import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/api/geocoding_api.dart';
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
    if (kDebugMode) {
      print("attempting to get weather");
      print("Value of city is : $city");
    }
   
    isLoading = true;
    notifyListeners();
    if (kDebugMode) {
      print("Notified listeners");
    }

    //getCityData();//updating city variable
    final WeatherData weather;
    String vCity;
    try {
      (weather,vCity) = await repository.getWeather(city: city);
      city = vCity;
      
    } catch (e) {
      if (kDebugMode) {
        print("Exeption found attempting to get weather from provider class");
      }
      isLoading = false;
      rethrow;

    }

     
    //print(weather.weatherInfo);
    //TODO set the weather and fetch forecast after
    currentWeatherProvider = weather;
    await getForecastData();
    //isLoading = false;
    

  }

  Future<void> getForecastData() async {
    // print("Attemping to get forecast");
    // print("Value of city is: ${city}");
    final ForecastData forecast;
    try {
      forecast = await repository.getForecast(city: city);
    } catch (e) {
      isLoading = false;
      rethrow;
    }
     
    
    //TODO set the forecast
    hourlyWeatherProvider = forecast;
    
    if (kDebugMode) {
      print("Forecast Successfully fetched");
    }
    
    isLoading = false;
    notifyListeners();
  }
}

  enum CelsiusOrFarenheit {
  celsius,
  farenheit,
}

class CelsiusOrFarenheitProvider extends ChangeNotifier{
  CelsiusOrFarenheit currentState = CelsiusOrFarenheit.celsius;

  getCurrentState(){
    return currentState;
  }

  toggleCurrentState(){
    if(currentState == CelsiusOrFarenheit.celsius){
      currentState = CelsiusOrFarenheit.farenheit;
      notifyListeners();
    }
    else if(currentState == CelsiusOrFarenheit.farenheit){
      currentState = CelsiusOrFarenheit.celsius;
      notifyListeners();
    }
  }
}




