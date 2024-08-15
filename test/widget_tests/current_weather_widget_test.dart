import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_weather_example_flutter/src/api/api_keys.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/current_weather.dart';
import 'package:provider/provider.dart';

void main() {
  group('CurrentWeather Widget Tests', () {
    // Test when data is loading
    testWidgets('displays CircularProgressIndicator when loading',
        (WidgetTester tester) async {
      // Create a mock WeatherProvider
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load();
      setupInjection();
      final weatherProvider = WeatherProvider();
      weatherProvider.isLoading = true; // Set loading state

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
      // Create a mock WeatherProvider with data
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load();
      setupInjection();
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

      // Verify the weather data is displayed
      expect(find.text('Test City'), findsOneWidget);
      expect(find.text('296'), findsOneWidget); // Check temperature
      expect(find.text('H:297° L:296°'), findsOneWidget); // Check high and low
    });

    group('displays error messages', () {    
    testWidgets('City not found',
        (WidgetTester tester) async {
      // Create a mock WeatherProvider with data
      WidgetsFlutterBinding.ensureInitialized();
      await dotenv.load();
      setupInjection();
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

      // Verify the weather data is displayed
      expect(find.text('City not found'), findsOneWidget);
    });

    // You can add more tests here for different scenarios, like handling errors or switching between Celsius and Fahrenheit.
  });
  });
}
