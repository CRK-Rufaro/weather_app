class GeocodingAPI{
  GeocodingAPI(this.apiKey);

  final String apiKey;

  static const String _apiBaseUrl = "api.openweathermap.org";
  static const String _apiPath = "/geo/1.0/";

  //for direct geocoding
  Uri directGeocoding(String city) => _buildUri(
        endpoint: "direct",
        parametersBuilder: () => queryParameters(city),
  );

  //implement reverse geocoding

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


  Map<String, dynamic> queryParameters(String city) => {
      "q": city,
      "appid": apiKey,
      "limit": "1",
    };
}