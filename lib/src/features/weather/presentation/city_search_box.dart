import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/constants/app_colors.dart';
import 'package:open_weather_example_flutter/src/features/weather/application/providers.dart';
import 'package:provider/provider.dart';

class CitySearchBox extends StatefulWidget {
  const CitySearchBox({super.key});

  @override
  State<CitySearchBox> createState() => _CitySearchRowState();
}

class _CitySearchRowState extends State<CitySearchBox> {
  static const _radius = 30.0;

  late final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.text = context.read<WeatherProvider>().city;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _buttonAction();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _buttonAction() async {
    FocusScope.of(context).unfocus();
    context.read<WeatherProvider>().city = _searchController.text;
    //TODO search weather
    await context.read<WeatherProvider>().getWeatherData();
    
  }

  // circular radius
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(_radius),
            bottomRight: Radius.circular(_radius),
          ),
        ),
        child: SizedBox(
            height: _radius*2 ,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black),
        
                    decoration: const InputDecoration(
                      labelText: 'Enter city name',
                      labelStyle: TextStyle(color: Colors.black54),
                      filled: true,
                    ),
        
                    //TODO make component functional and add style
                  ),
                ),
                InkWell(
                  
                  onTap: _buttonAction,
                  
                  child: Container(
                    height: _radius * 2 ,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: AppColors.accentColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(_radius),
                        bottomRight: Radius.circular(_radius),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('search',
                          style: Theme.of(context).textTheme.bodyLarge),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
