import 'package:open_weather_example_flutter/src/features/weather/data/city_data.dart';

/// Uri builder class for the OpenWeatherMap API
class OpenWeatherMapAPI {
  OpenWeatherMapAPI(this.apiKey);

  final String apiKey;

  static const String _apiBaseUrl = "api.openweathermap.org";
  static const String _apiPath = "/data/2.5/";

  Uri weather(CityData city) => _buildUri(
        endpoint: "weather",
        parametersBuilder: () => cityQueryParameters(city),
      );

  Uri forecast(CityData city) => _buildUri(
        endpoint: "forecast",
        parametersBuilder: () => cityQueryParameters(city),
      );

  Uri _buildUri({
    required String endpoint,
    required Map<String, dynamic> Function() parametersBuilder,
  }) {
    return Uri(
      scheme: "https",
      host: _apiBaseUrl,
      path: "$_apiPath$endpoint",
      queryParameters: parametersBuilder(),
    );
  }

  Map<String, dynamic> cityQueryParameters(CityData city) => {
        //"q": city,
        "lat":city.latitude.toString(),
        "lon":city.longitude.toString(),
        "appid": apiKey,
        "units": "metric",
        "type": "like",
        "cnt": "30",
      };
}
