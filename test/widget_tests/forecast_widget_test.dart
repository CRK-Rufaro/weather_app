import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/forecast_widget.dart';
import 'package:provider/provider.dart';


void main() {
  group('Forecast Widget Tests', () {
    
      List<WeatherData> weatherDataList = [];
      WeatherData one = WeatherData(
          dtSunset: DateTime.fromMillisecondsSinceEpoch(1661882248 * 1000,
              isUtc: true),
          dtCurrent: DateTime.fromMillisecondsSinceEpoch(1661871600 * 1000,
              isUtc: true),
          temp: Temperature(defaultTemperature: 296.76),
          minTemp: Temperature(defaultTemperature: 296.76),
          maxTemp: Temperature(defaultTemperature: 297.87),
          weatherInfo: {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10d"
          },
          iconUrl: "https://openweathermap.org/img/wn/10d.png");

      WeatherData two = WeatherData(
          dtSunset: DateTime.fromMillisecondsSinceEpoch(1661882248 * 1000,
              isUtc: true),
          dtCurrent: DateTime.fromMillisecondsSinceEpoch(1661882400 * 1000,
              isUtc: true),
          temp: Temperature(defaultTemperature: 295.45),
          minTemp: Temperature(defaultTemperature: 292.84),
          maxTemp: Temperature(defaultTemperature: 295.45),
          weatherInfo: {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          },
          iconUrl: "https://openweathermap.org/img/wn/10n.png");

      WeatherData three = WeatherData(
          dtSunset: DateTime.fromMillisecondsSinceEpoch(1661882248 * 1000,
              isUtc: true),
          dtCurrent: DateTime.fromMillisecondsSinceEpoch(1661893200 * 1000,
              isUtc: true),
          temp: Temperature(defaultTemperature: 292.46),
          minTemp: Temperature(defaultTemperature: 290.31),
          maxTemp: Temperature(defaultTemperature: 292.46),
          weatherInfo: {
            "id": 500,
            "main": "Rain",
            "description": "light rain",
            "icon": "10n"
          },
          iconUrl: "https://openweathermap.org/img/wn/10n.png");

      WeatherData four = WeatherData(
          dtSunset: DateTime.fromMillisecondsSinceEpoch(1661882248 * 1000,
              isUtc: true),
          dtCurrent: DateTime.fromMillisecondsSinceEpoch(1662292800 * 1000,
              isUtc: true),
          temp: Temperature(defaultTemperature: 294.93),
          minTemp: Temperature(defaultTemperature: 294.93),
          maxTemp: Temperature(defaultTemperature: 294.93),
          weatherInfo: {
            "id": 804,
            "main": "Clouds",
            "description": "overcast clouds",
            "icon": "04d"
          },
          iconUrl: "https://openweathermap.org/img/wn/04d.png");

      weatherDataList.addAll([one, two, three, four]);

      ForecastData forecastData = ForecastData(forecast: weatherDataList);
    
    testWidgets('displays CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      final GetIt getIt = GetIt.instance;
      getIt.registerSingleton<String>('your_api_key_here',
          instanceName: 'api_key');

      GetIt.instance.reset();
      final weatherProvider = WeatherProvider();
      weatherProvider.isLoading = true;
      weatherProvider.hourlyWeatherProvider = forecastData;
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherProvider>.value(
                value: weatherProvider),
            ChangeNotifierProvider<CelsiusOrFarenheitProvider>(
              create: (_) => CelsiusOrFarenheitProvider(),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ForecastWidget(),
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('No forecast data found',
        (WidgetTester tester) async {
      final GetIt getIt = GetIt.instance;
      getIt.registerSingleton<String>('your_api_key_here',
          instanceName: 'api_key');

      GetIt.instance.reset();
      final weatherProvider = WeatherProvider();
      weatherProvider.isLoading = false;
      weatherProvider.hourlyWeatherProvider = ForecastData(forecast: []);
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<WeatherProvider>.value(
                value: weatherProvider),
            ChangeNotifierProvider<CelsiusOrFarenheitProvider>(
              create: (_) => CelsiusOrFarenheitProvider(),
            ),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ForecastWidget(),
            ),
          ),
        ),
      );
      expect(find.text("No forecast data found"), findsOneWidget);
    });


  });
}
