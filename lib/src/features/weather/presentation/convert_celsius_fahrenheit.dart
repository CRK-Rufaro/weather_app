import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:open_weather_example_flutter/src/features/weather/data/weather_data.dart';
import 'package:provider/provider.dart';

class ConvertCelsiusFahrenheit extends StatelessWidget {
  const ConvertCelsiusFahrenheit({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text("Celsius / Farenheit"),
        IconButton(onPressed: (){
          Provider.of<CelsiusOrFarenheitProvider>(context,listen: false).toggleCurrentState();           
        }, icon: const Icon(Icons.autorenew,color: Colors.white,)),
      ],
    );
  }
}