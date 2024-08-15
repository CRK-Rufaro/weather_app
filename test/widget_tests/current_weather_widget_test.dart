import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/current_weather.dart';
import 'package:provider/provider.dart';

void main() {
  group('CurrentWeather Widget Tests', () {
    // Test when data is loading
    testWidgets('displays CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      final GetIt getIt = GetIt.instance;
      getIt.registerSingleton<String>('your_api_key_here',
          instanceName: 'api_key');
      GetIt.instance.reset();

      final weatherProvider = WeatherProvider();
      weatherProvider.isLoading = true; 

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
              body: CurrentWeather(),
            ),
          ),
        ),
      );

      // Verify CircularProgressIndicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    // Test when data is loaded
    testWidgets('displays weather data when loaded',
        (WidgetTester tester) async {
      final GetIt getIt = GetIt.instance;
      getIt.registerSingleton<String>('your_api_key_here',
          instanceName: 'api_key');
      GetIt.instance.reset();

      // Mock WeatherProvider with data
      final weatherProvider = WeatherProvider();
      weatherProvider.city = "Test City";
      weatherProvider.isLoading = false; // Set not loading
      weatherProvider.currentWeatherProvider = WeatherData(
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
              body: CurrentWeather(),
            ),
          ),
        ),
      );

      // Verify data is displayed
      expect(find.text('Test City'), findsOneWidget);
      expect(find.text('296'), findsOneWidget); 
      expect(find.text('H:297° L:296°'), findsOneWidget); 
    });

    group('displays error messages', () {
      testWidgets('City not found', (WidgetTester tester) async {
        final GetIt getIt = GetIt.instance;
        getIt.registerSingleton<String>('your_api_key_here',
            instanceName: 'api_key');
        GetIt.instance.reset();

        final weatherProvider = WeatherProvider();
        weatherProvider.hasError = true;
        weatherProvider.errorMessage = "City not found";

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
                body: CurrentWeather(),
              ),
            ),
          ),
        );


        expect(find.text('City not found'), findsOneWidget);
      });
    });
  });
}
