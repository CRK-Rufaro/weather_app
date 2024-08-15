import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/city_search_box.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/convert_celsius_fahrenheit.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/current_weather.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/forecast_widget.dart';

class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key, required this.city});
  final String city;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.bottom - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width - MediaQuery.of(context).padding.left - MediaQuery.of(context).padding.right;

    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Container(
            height: height,
            width: width,
                
            //width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.rainGradient,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //Spacer(),
                Container(
                  alignment: Alignment.center,
                  //color: Colors.deepPurpleAccent,
                  height: height*0.4,
                  width: width,
                  child: CurrentWeather()),
                
                Container(
                  alignment: Alignment.center,
                  //color: Colors.brown,
                  height: height*0.25,
                  child: ForecastWidget()),
                //Spacer(),
                Container(
                  //height: MediaQuery.of(context).size.height*0.07,
                  //padding: EdgeInsets.fromLTRB(30, 20, 30, 0),
                  //color: Colors.lime,
                  alignment: Alignment.bottomRight,
                  child: ConvertCelsiusFahrenheit()),
                //Spacer(),
                Expanded(
                  child: Container(
                    //color: Colors.amber,
                    alignment: Alignment.center,
                    //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    //height: MediaQuery.of(context).size.height*0.18,
                    child: CitySearchBox()),
                ),
                  //const Spacer(),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}


