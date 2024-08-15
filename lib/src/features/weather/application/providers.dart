import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/api/geocoding_api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
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


  String city = 'London'; 

  
  
  
  

  WeatherData? currentWeatherProvider;
  ForecastData? hourlyWeatherProvider;

  bool isLoading =  false;

  bool hasError = false;
  String errorMessage = '';

  void resetError() {
    hasError = false;
    errorMessage = '';
    notifyListeners();
  }



  Future<void> getWeatherData() async {

    resetError();   
    isLoading = true;
    notifyListeners();

    WeatherData weather;
    String vCity;
    try {
      (weather,vCity) = await repository.getWeather(city: city);
      city = vCity;
      
      currentWeatherProvider = weather;
      await getForecastData();
    
      
    } catch (e) {
      hasError = true;
      errorMessage = e is APIException ? e.message : e.toString();
      
      

      hourlyWeatherProvider = null;
      isLoading = false;
      notifyListeners();

    }

     

    //TODO set the weather and fetch forecast after


  }

  Future<void> getForecastData() async {

    final ForecastData forecast;
    try {
      forecast = await repository.getForecast(city: city);
    } catch (e) {
      isLoading = false;
      rethrow;
    }
     
    
    //TODO set the forecast
    hourlyWeatherProvider = forecast;
    
    
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




