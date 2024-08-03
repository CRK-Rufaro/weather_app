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
              List<WeatherData> forecastList = processedTimeSteps(data.forecastData!.forecast);
              List<SingularTimeStepForecastWidget> forecastListWidgets = [];
              for (var element in forecastList){
                forecastListWidgets.add(SingularTimeStepForecastWidget(timeStep: element));
              }
              //List<SingularTimeStepForecastWidget> forecastListWidgets = forecastList.map((toElement)=>SingularTimeStepForecastWidget(timeStep: toElement))as List<SingularTimeStepForecastWidget>;
              return Container(
                //color: Colors.amber,
                  //height: MediaQuery.of(context).size.height*0.2,
                  child: Center(
                    child: Row(
                      //mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:  forecastListWidgets,
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
          return const CircularProgressIndicator();
        });
  }
}

List<WeatherData> processedTimeSteps(List<WeatherData> rawTimeSteps) {
  List <WeatherData>trimmedTimeSteps = [];
  List presentDays = [];
  // presentDays.add(rawTimeSteps.first.dtCurrent.weekday);
  // trimmedTimeSteps.add(rawTimeSteps.first);
  for (var element in rawTimeSteps){
    if (!presentDays.contains(element.dtCurrent.weekday)) {
      trimmedTimeSteps.add(element);
      presentDays.add(element.dtCurrent.weekday);
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
        // Get screen width
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool resize(){
      if(MediaQuery.of(context).orientation == Orientation.landscape){
        if(MediaQuery.of(context).size.width>MediaQuery.of(context).size.height*2){
          return true;          
        }
        return false;
      }

      return false;
    }


    
    

    // Calculate sizes based on screen width
    double iconSize = resize()?screenHeight * 0.1 : screenWidth * 0.2; // 20% of screen width
    double fontSize = resize()?screenHeight * 0.03 : screenWidth * 0.03; // 4% of screen width
    List<String> daysOfWeek = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    String dayName = daysOfWeek[timeStep.dtCurrent.weekday - 1].substring(0,3);

    return Container(
      //color: Colors.cyan,
      child: Column(
        //mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        
        children: [
          //day
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              //color: Colors.cyan,
              child: Text(dayName,style: TextStyle(
                color: Colors.white70,
                fontSize: fontSize),)),
          ),
          //icon
          Expanded(
            flex: 3,
            child: Container(
              //color: Colors.black,
            child: WeatherIconImage(iconUrl: timeStep.iconUrl, size: iconSize)),
          ),
          //temperature
          Expanded(
            flex: 2,
            child: Container(
              alignment: Alignment.center,
              
              //color: Colors.blue,
              child: Text("${timeStep.temp.celsius.round()}°",style: TextStyle(fontSize: fontSize*0.8),)),
          ),
        ],
      ),
    );
  }
}
