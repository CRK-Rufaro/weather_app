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
            if (data.isLoading == true) {
              return const CircularProgressIndicator();
            }
            if (data.isLoading == false) {
              List<WeatherData> forecastList =
                  processedTimeSteps(data.forecastData!.forecast);
              List<SingularTimeStepForecastWidget> forecastListWidgets = [];
              for (var element in forecastList) {
                forecastListWidgets
                    .add(SingularTimeStepForecastWidget(timeStep: element));
              }
              //List<SingularTimeStepForecastWidget> forecastListWidgets = forecastList.map((toElement)=>SingularTimeStepForecastWidget(timeStep: toElement))as List<SingularTimeStepForecastWidget>;
              return Container(
                  //color: Colors.amber,
                  //height: MediaQuery.of(context).size.height*0.2,
                  width:MediaQuery.of(context).size.width - MediaQuery.of(context).padding.left - MediaQuery.of(context).padding.right,
                  child: Center(
                      child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: forecastListWidgets,
              )
                      // ListView.builder(

                      //     itemCount: forecastList.length,
                      //     scrollDirection: Axis.horizontal,
                      //     itemBuilder: (context, index) {
                      //       return SingularTimeStepForecastWidget(
                      //           timeStep: forecastList[index]);
                      //     }),
                      ));
              // return Column(
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     // Text(data.city,
              //     //     style: Theme.of(context).textTheme.headlineMedium),

              //     //CurrentWeatherContents(data: data.weatherData!),
              //   ],
              // );
            }
          }
          //return const CircularProgressIndicator();
          return const SizedBox();
          //Text("Start searching for city",style: Theme.of(context).textTheme.headlineMedium);
        });
  }
}

List<WeatherData> processedTimeSteps(List<WeatherData> rawTimeSteps) {
  List<WeatherData> trimmedTimeSteps = [];
  List presentDays = [];
  // presentDays.add(rawTimeSteps.first.dtCurrent.weekday);
  // trimmedTimeSteps.add(rawTimeSteps.first);
  for (var element in rawTimeSteps) {
    if (presentDays.length < 5) {
      if (!presentDays.contains(element.dtCurrent.weekday)) {
        trimmedTimeSteps.add(element);
        presentDays.add(element.dtCurrent.weekday);
      }
    }
  }

  // rawTimeSteps.forEach((element) {

  // });
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
    CelsiusOrFarenheit currentState = Provider.of<CelsiusOrFarenheitProvider>(context).currentState;
    bool isCelsius = currentState == CelsiusOrFarenheit.celsius;

    // Get screen width
    double screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - MediaQuery.of(context).padding.top;
    double screenWidth = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.left - MediaQuery.of(context).padding.right;

    bool resize() {
      if (MediaQuery.of(context).orientation == Orientation.landscape) {
        if (MediaQuery.of(context).size.width >
            MediaQuery.of(context).size.height * 2) {
          return true;
        }
        return false;
      }

      return false;
    }

    // Calculate sizes based on screen width
    double iconSize = resize()
        ? screenHeight * 0.18
        : screenWidth * 0.18; // 20% of screen width
    double fontSize = resize()
        ? screenHeight * 0.05
        : screenWidth * 0.05; // 4.5% of screen width or height
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
    int temp = isCelsius?timeStep.temp.celsius.round():timeStep.temp.farenheight.round();

    return Container(
      //color: Colors.cyan,
      width: screenWidth/5,

      child: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //day
          Expanded(
            flex: 1,
            child: Container(
                //alignment: Alignment.center,
                //color: Colors.blueGrey,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    dayName,
                    style: TextStyle(color: Colors.white70, fontSize: fontSize),
                  ),
                )),
          ),
          //icon
          Expanded(
            flex: 3,
            child: FittedBox(
                  fit: BoxFit.contain,

              child: Container(
                  //color: Colors.black,
                  //padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: WeatherIconImage(
                      iconUrl: timeStep.iconUrl, size: iconSize)),
            ),
          ),
          //temperature
          Expanded(
            flex: 1,
            child: Container(
              //color: Colors.red,
              child: FittedBox(
                    fit: BoxFit.contain,
                child: Text(
                  " $temp°",
                  style: TextStyle(fontSize: fontSize * 0.9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
