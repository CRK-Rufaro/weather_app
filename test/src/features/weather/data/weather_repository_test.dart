import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:open_weather_example_flutter/src/api/api.dart';
import 'package:open_weather_example_flutter/src/api/geocoding_api.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/city_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_repository.dart';

class MockHttpClient extends Mock implements http.Client {
  // @override
  // Future<Response> get(Uri url, {Map<String, String>? headers}){
  //   return 
  // }
}

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

void main() {
  test('repository with mocked http client, success', () async {
    final mockCityData = CityData(name: "London", latitude: 51.5073219, longitude: -0.1276474, country: "GB");
    final mockHttpClient = MockHttpClient();
    final api = OpenWeatherMapAPI('apiKey');
    final weatherRepository = HttpWeatherRepository(api: api, client: mockHttpClient);
    //TODO Mock http and ensure weather is correct

    
    // test("tests", (){
    // WeatherData result = weatherRepository.getWeather(city: mockCityData);
    // })
  });

  test('repository with mocked http client, failure', () async {
    final mockHttpClient = MockHttpClient();
    final api = OpenWeatherMapAPI('apiKey');
    //final weatherRepository = HttpWeatherRepository(api: api, client: mockHttpClient);
    //TODO Mock http 404 and ensure api returns CityNotFoundException
  });

  //TODO test providers data as well



}

class MockHttpWeatherRepository implements HttpWeatherRepository{
  @override
  // TODO: implement api
  OpenWeatherMapAPI get api => throw UnimplementedError();

  @override
  // TODO: implement client
  http.Client get client => throw UnimplementedError();

  @override
  // TODO: implement geoApi
  GeocodingAPI get geoApi => throw UnimplementedError();

  @override
  Future<CityData> getCity({required String city}) {
    // TODO: implement getCity
    throw UnimplementedError();
  }

  @override
  getForecast({required CityData city}) {
    // TODO: implement getForecast
    throw UnimplementedError();
  }

  @override
  getWeather({required CityData city}) {
    // TODO: implement getWeather
    throw UnimplementedError();
  }

}
