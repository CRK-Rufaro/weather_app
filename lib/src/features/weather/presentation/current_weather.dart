import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_icon_image.dart';
import 'package:provider/provider.dart';


class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});
  
  @override
  Widget build(BuildContext context) {    
    return Consumer<CelsiusOrFarenheitProvider>(
      builder: (context, celsiusOrFarenheitProvider, child) => 
      Selector<WeatherProvider, 
      ({String city, WeatherData? weatherData, bool isLoading, bool hasError, String errorMessage})>(
          selector: (context, provider) => (city: provider.city, weatherData: provider.currentWeatherProvider,isLoading:provider.isLoading,hasError:provider.hasError, errorMessage:provider.errorMessage),
          builder: (context, data, _) {
            if(data.hasError){
              return Center(child: Text(data.errorMessage,style:const TextStyle(color: Colors.white,fontSize:20),),);
            }
            if(data.weatherData!=null){
              if(data.isLoading==true){
              return const CircularProgressIndicator(color: Colors.white,);
            }
            if(data.isLoading==false){
            return FittedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    //color: Colors.black,
                    child: Text(data.city, style: Theme.of(context).textTheme.headlineMedium)),
                    
                  //TODO account for null, errors and loading states
                  //if data.$2!=null{}
                  Container(
                    //color: Colors.amber,
                    child: CurrentWeatherContents(data: data.weatherData!)),
                ],
              ),
            );}
            }
            //Immediately Loads into London Search Results
            return const CircularProgressIndicator(color: Colors.white,);
            
            //Loads into Welcome Screen and then London Search Results
            //return Text("Welcome",style: Theme.of(context).textTheme.displayMedium);
            
          }),
    );
  }
}

class CurrentWeatherContents extends StatelessWidget {
  const CurrentWeatherContents({super.key, required this.data, });

  final WeatherData data;
  

  @override
  Widget build(BuildContext context) {
    bool resize(){
      if(MediaQuery.of(context).orientation == Orientation.landscape){
        if(MediaQuery.of(context).size.width>MediaQuery.of(context).size.height*2){
          return true;          
        }
        return false;
      }

      return false;
    }

    final textTheme = Theme.of(context).textTheme;
    final double iconSize = resize()?50:120;
    final textSize = resize()?textTheme.displaySmall:textTheme.displayMedium;

    CelsiusOrFarenheit currentState = Provider.of<CelsiusOrFarenheitProvider>(context).currentState;
    bool isCelsius = currentState == CelsiusOrFarenheit.celsius;

    final temp = isCelsius?data.temp.celsius.toInt().toString():data.temp.farenheight.toInt().toString();
    final minTemp = isCelsius?data.minTemp.celsius.toInt().toString():data.minTemp.farenheight.toInt().toString();
    final maxTemp = isCelsius?data.maxTemp.celsius.toInt().toString():data.maxTemp.farenheight.toInt().toString();
    final highAndLow = 'H:$maxTemp° L:$minTemp°';
  
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        WeatherIconImage(iconUrl: data.iconUrl, size: iconSize),//120
        Text(temp, style: textSize),
        Text(highAndLow, style: textTheme.bodyMedium),
      ],
    );
  }
}

