import 'dart:io';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/geocoding_api.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/city_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';

class MockHttpClient extends Mock implements http.Client {
}

class MockHttpWeatherRepository extends Mock implements HttpWeatherRepository{

}

//Registering fake classes for Uri
class UriFake extends Fake implements Uri {}

//Example JSON Responses for testing
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

//List<Map<String,dynamic>> mockedJson =                 
const encodedCityJsonResponse ="""  
[
    {
        "name": "Mountain View",
        "local_names": {
            "en": "Mountain View"
        },
        "lat": 37.3893889,
        "lon": -122.0832101,
        "country": "US",
        "state": "California"
    },
    {
        "name": "Mountain View",
        "lat": 35.8684075,
        "lon": -92.1176521,
        "country": "US",
        "state": "Arkansas"
    },
    {
        "name": "Mountain View",
        "lat": 38.0088105,
        "lon": -122.1174648,
        "country": "US",
        "state": "California"
    },
    {
        "name": "Mountain View",
        "lat": 49.133333,
        "lon": -113.6,
        "country": "CA",
        "state": "Alberta"
    }
]
""";
// final expectedWeatherFromJson = Weather(
//   weatherParams: WeatherParams(temp: 282.55, tempMin: 280.37, tempMax: 284.26),
//   weatherInfo: [
//     WeatherInfo(
//       description: 'clear sky',
//       icon: '01d',
//       main: 'Clear',
//     )
//   ],
//   dt: 1560350645,
// );

//Expected Weather data to be parsed from the JSON Response, Used for matching
final expectedWeatherFromJson = WeatherData(temp: Temperature(defaultTemperature: 282.55), minTemp: Temperature(defaultTemperature: 280.37), maxTemp: Temperature(defaultTemperature: 284.26), weatherInfo: {    
      "id": 800,
      "main": "Clear",
      "description": "clear sky",
      "icon": "01d"
    }, iconUrl: "https://openweathermap.org/img/wn/01d.png");


void main() {
    //TestWidgetsFlutterBinding.ensureInitialized();
    late MockHttpClient mockHttpClient;
    late OpenWeatherMapAPI api;
    late GeocodingAPI geoApi;
    late HttpWeatherRepository weatherRepository;

  setUpAll(() {
    // Registering fallback values for Uri
    registerFallbackValue(UriFake());
  });

  //Initialising variables
  setUp((){
    mockHttpClient = MockHttpClient();
    api = OpenWeatherMapAPI('apiKey');
    geoApi = GeocodingAPI('apiKey');
    weatherRepository = HttpWeatherRepository(api: api, client: mockHttpClient, geoApi: geoApi);
  });

    //Grouping to reduce duplication
    group("Testing Http Repository", (){
    test('repository with mocked http client, success', () async {
    //TODO Mock http and ensure weather is correct
    when(() => mockHttpClient.get(any(that: isA<Uri>())))
        .thenAnswer((invocation) async {
      final uri = invocation.positionalArguments[0] as Uri;
      //print("providing mock response");
      //print("the current uri path:"+ uri.path.toString());

      if (uri.path.contains('direct')) {
        //print("retruned mock response for geolocater");
        return Response(encodedCityJsonResponse, 200);
      }
      //print("retruned mock response for weather");
      return Response(encodedWeatherJsonResponse, 200);
    });
   
    var result = await weatherRepository.getWeather(city: "Mountain View");
    expect(result.iconUrl, expectedWeatherFromJson.iconUrl);
    expect(result.maxTemp.celsius, expectedWeatherFromJson.maxTemp.celsius);
    expect(result.minTemp.farenheight, expectedWeatherFromJson.minTemp.farenheight);
    expect(result.temp.defaultTemperature, expectedWeatherFromJson.temp.defaultTemperature);
    expect(result.weatherInfo, expectedWeatherFromJson.weatherInfo);
  });

    test('repository with mocked http client, failure', () async {
  //TODO Mock http 404 and ensure api returns CityNotFoundException

    when(() => mockHttpClient.get(any())).thenAnswer((_) async => Response('', 404)); 
    expect(()=> weatherRepository.getWeather(city: "Mountain View"), throwsA (isA<CityNotFoundException>()));
  });

  //network errors
      test('repository with mocked http client, Invalid API', () async {
      // Mock HTTP client response for Invalid Api
      when(() => mockHttpClient.get(any())).thenAnswer((_)async=>Response('', 403));
      expect(() => weatherRepository.getWeather(city: "Mountain View"), throwsA(isA<InvalidApiKeyException>()));
      });

  });

    //TODO test providers data as well
group('WeatherProvider', () {
    late WeatherProvider weatherProvider;
    late MockHttpWeatherRepository mockWeatherRepository;
    final getIt = GetIt.instance;

          final WeatherData weatherData = expectedWeatherFromJson;

          List<WeatherData> weatherDataList = [];
WeatherData one = WeatherData(temp: Temperature(defaultTemperature: 296.76), minTemp: Temperature(defaultTemperature: 296.76), maxTemp: Temperature(defaultTemperature: 297.87), 
  weatherInfo: {
      "id": 500,
      "main": "Rain",
      "description": "light rain",
      "icon": "10d"
    }, iconUrl: "https://openweathermap.org/img/wn/10d.png");

WeatherData two = WeatherData(temp: Temperature(defaultTemperature: 295.45), minTemp: Temperature(defaultTemperature: 292.84), maxTemp: Temperature(defaultTemperature: 295.45), 
  weatherInfo: {
      "id": 500,
      "main": "Rain",
      "description": "light rain",
      "icon": "10n"
    }, iconUrl: "https://openweathermap.org/img/wn/10n.png");

WeatherData three = WeatherData(temp: Temperature(defaultTemperature: 292.46), minTemp: Temperature(defaultTemperature: 290.31), maxTemp: Temperature(defaultTemperature: 292.46), 
  weatherInfo: {
      "id": 500,
      "main": "Rain",
      "description": "light rain",
      "icon": "10n"
    }, iconUrl: "https://openweathermap.org/img/wn/10n.png");

WeatherData four = WeatherData(temp: Temperature(defaultTemperature: 294.93), minTemp: Temperature(defaultTemperature: 294.93), maxTemp: Temperature(defaultTemperature: 294.93), 
  weatherInfo: {
      "id": 804,
      "main": "Clouds",
      "description": "overcast clouds",
      "icon": "04d"
    }, iconUrl: "https://openweathermap.org/img/wn/04d.png");

weatherDataList.addAll([one,two,three,four]);

      final forecastData = ForecastData(
        forecast: weatherDataList
      );

    // mockWeatherRepository = HttpWeatherRepository(
    //   api: mockOpenWeatherMapAPI,
    //   client: mockClient,
    //   geoApi: mockGeocodingAPI,
    // );

    setUp(() {
      getIt.registerSingleton<String>('test_api_key', instanceName: 'api_key');
      mockWeatherRepository = MockHttpWeatherRepository();
      weatherProvider = WeatherProvider();
      weatherProvider.repository = mockWeatherRepository;
    });
    
    tearDown(() {
    // Reset GetIt after each test to avoid side effects
    getIt.reset();
  });




    test('should fetch weather data successfully', () async {

      

      when(() => mockWeatherRepository.getWeather(city: 'Mountain View')).thenAnswer((_) async => weatherData);
      when(() => mockWeatherRepository.getForecast(city: 'Mountain View')).thenAnswer((_) async => forecastData);

      weatherProvider.city = "Mountain View";
      await weatherProvider.getWeatherData();
      //await weatherProvider.getForecastData();

      expect(weatherProvider.currentWeatherProvider, weatherData);
      expect(weatherProvider.hourlyWeatherProvider, forecastData);
      expect(weatherProvider.isLoading, false);
    });

    test('should handle loading state', () async {
      when(() => mockWeatherRepository.getWeather(city: 'Mountain View')).thenAnswer((_) async {
        await Future.delayed(Duration(milliseconds: 500));
        return weatherData;
      });
      when(() => mockWeatherRepository.getForecast(city: 'Mountain View')).thenAnswer((_) async {
        await Future.delayed(Duration(seconds: 1));
        return forecastData;
      } );
      weatherProvider.city = "Mountain View";
      final future = weatherProvider.getWeatherData();

      expect(weatherProvider.isLoading, true);

      await future;

      expect(weatherProvider.isLoading, false);
    });

    test('should handle error state', () async {
      when(() => mockWeatherRepository.getWeather(city: 'Mountain View')).thenThrow(UnknownException());
      //when(() => mockWeatherRepository.getForecast(city: 'Mountain View')).thenAnswer((_) async => forecastData);
      weatherProvider.city = "Mountain View";
      expect(()=> weatherProvider.getWeatherData(), throwsA (isA<UnknownException>()));
      try {
        await weatherProvider.getWeatherData();        
      } catch (e) {
        expect(weatherProvider.currentWeatherProvider, null);
        expect(weatherProvider.hourlyWeatherProvider, null);
        expect(weatherProvider.isLoading, false);
      }
    });
  });



}

