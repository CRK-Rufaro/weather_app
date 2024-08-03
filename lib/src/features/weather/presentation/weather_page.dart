import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/forecast_widget.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key, required this.city});
  final String city;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: AppColors.rainGradient,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  //color: Colors.deepPurpleAccent,
                  height: MediaQuery.of(context).size.height*0.4,
                  width: MediaQuery.of(context).size.width,
                  child: CurrentWeather()),
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  //color: Colors.brown,
                  height: MediaQuery.of(context).size.height*0.25,
                  child: ForecastWidget()),
                Spacer(),
                Container(
                  //color: Colors.amber,
                  height: MediaQuery.of(context).size.height*0.2,
                  child: CitySearchBox()),
                Spacer(),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}


