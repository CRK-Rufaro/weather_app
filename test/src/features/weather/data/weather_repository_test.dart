import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/geocoding_api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/api_exception.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/city_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';

class MockHttpClient extends Mock implements http.Client {
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
  TestWidgetsFlutterBinding.ensureInitialized();
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
      test('repository with mocked http client, network timeout', () async {
      // Mock HTTP client response for network timeout
      when(() => mockHttpClient.get(any())).thenAnswer((_)async=>Response('', 403));

      // Expect the repository to throw a network-related exception
      expect(() => weatherRepository.getWeather(city: "Mountain View"), throwsA(isA<InvalidApiKeyException>()));
      });

  });

    //TODO test providers data as well
    group("Testing Weather Provider", (){
      
    });
  



}

