import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/forecast_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_icon_image.dart';
import 'package:provider/provider.dart';

class ForecastWidget extends StatelessWidget {
  const ForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<WeatherProvider,
            ({String city, ForecastData? forecastData, bool isLoading})>(
        selector: (context, provider) => (
              city: provider.city,
              forecastData: provider.hourlyWeatherProvider,
              isLoading: provider.isLoading
            ),
        builder: (context, data, _) {
          if (data.forecastData != null) {
            if(data.forecastData!.forecast.isEmpty){
                return const Center(child: Text("No forecast data found",style: TextStyle(color: Colors.white),));
            }
            if (data.isLoading == true) {
              return const CircularProgressIndicator(
                color: Colors.white,
              );
            }
            if (data.isLoading == false) {
              List<WeatherData> forecastList =
                  processedTimeSteps(data.forecastData!.forecast);
              List<SingularTimeStepForecastWidget> forecastListWidgets = [];
              for (var element in forecastList) {
                forecastListWidgets
                    .add(SingularTimeStepForecastWidget(timeStep: element));
              }
              return SafeArea(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: forecastListWidgets,
                ),
              );
            }
          }
          return const SizedBox();
        });
  }
}

List<WeatherData> processedTimeSteps(List<WeatherData> rawTimeSteps) {
  List<WeatherData> trimmedTimeSteps = [];
  List presentDays = [];
  for (var element in rawTimeSteps) {
    if (presentDays.length < 5) {
      if (!presentDays.contains(element.dtCurrent.weekday)) {
        trimmedTimeSteps.add(element);
        presentDays.add(element.dtCurrent.weekday);
      }
    }
  }
  return trimmedTimeSteps;
}

class SingularTimeStepForecastWidget extends StatelessWidget {
  final WeatherData timeStep;
  const SingularTimeStepForecastWidget({
    super.key,
    required this.timeStep,
  });

  @override
  Widget build(BuildContext context) {
    CelsiusOrFarenheit currentState =
        Provider.of<CelsiusOrFarenheitProvider>(context).currentState;
    bool isCelsius = currentState == CelsiusOrFarenheit.celsius;

    // Get screen width
    double screenHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.bottom -
        MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width -
        MediaQuery.of(context).padding.left -
        MediaQuery.of(context).padding.right;

    List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    String dayName = daysOfWeek[timeStep.dtCurrent.weekday - 1].substring(0, 3);
    int temp = isCelsius
        ? timeStep.temp.celsius.round()
        : timeStep.temp.farenheight.round();

    return SizedBox(
      //color: Colors.cyan,
      width: screenWidth / 6,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //day
          Expanded(
            flex: 1,
            child: FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
            dayName,
            style: const TextStyle(color: Colors.white70, fontSize: 10),
                          ),
                        ),
          ),
          //icon
          Expanded(
            flex: 3,
            child: FittedBox(
              fit: BoxFit.contain,
              child: WeatherIconImage(
                  iconUrl: timeStep.iconUrl, size: 120),
            ),
          ),
          //temperature
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                " $temp°",
                style: const TextStyle(fontSize: 10 * 0.9),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
