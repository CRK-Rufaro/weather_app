
import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:provider/provider.dart';

class ConvertCelsiusFahrenheit extends StatelessWidget {
  const ConvertCelsiusFahrenheit({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text("Celsius / Farenheit"),
        IconButton(onPressed: (){
          Provider.of<CelsiusOrFarenheitProvider>(context,listen: false).toggleCurrentState();           
        }, icon: const Icon(Icons.autorenew,color: Colors.white,)),
      ],
    );
  }
}