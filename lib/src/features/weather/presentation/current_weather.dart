import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_icon_image.dart';
import 'package:provider/provider.dart';


class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key});
  
  @override
  Widget build(BuildContext context) {
    
    return Selector<WeatherProvider, (String city, WeatherData? weatherData, bool isLoading)>(
        selector: (context, provider) => (provider.city, provider.currentWeatherProvider,provider.isLoading),
        builder: (context, data, _) {
          // if(data.$2==null){
          // //print("there might be a problem");
          //   if(data.$3==true){
          //   return const CircularProgressIndicator();
          // }
          // }

          if(data.$2!=null){
            if(data.$3==true){
            return const CircularProgressIndicator();
          }
          if(data.$3==false){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(data.$1, style: Theme.of(context).textTheme.headlineMedium),

              //TODO account for null, errors and loading states
              //if data.$2!=null{}
              CurrentWeatherContents(data: data.$2!),
            ],
          );}
          }
          return const CircularProgressIndicator();
        });
  }
}

class CurrentWeatherContents extends StatelessWidget {
  const CurrentWeatherContents({super.key, required this.data});

  final WeatherData data;
  

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final temp = data.temp.celsius.toInt().toString();
    final minTemp = data.minTemp.celsius.toInt().toString();
    final maxTemp = data.maxTemp.celsius.toInt().toString();
    final highAndLow = 'H:$maxTemp° L:$minTemp°';
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WeatherIconImage(iconUrl: data.iconUrl, size: 120),
        Text(temp, style: textTheme.displayMedium),
        Text(highAndLow, style: textTheme.bodyMedium),
      ],
    );
  }
}
