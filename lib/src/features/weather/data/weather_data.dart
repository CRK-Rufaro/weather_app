class WeatherData {
  final Temperature temp;
  final Temperature minTemp;
  final Temperature maxTemp;
  final String iconUrl;
  final Map <String,dynamic> weatherInfo;

  // "weather": [
	// {
	//   "id": 500,
	//   "main":"Rain",
	//   "description": "light rain",
	//   "icon": "10n"
	// }
  // ],

  WeatherData({required this.temp, required this.minTemp, required this.maxTemp, required this.weatherInfo, required this.iconUrl});


  factory WeatherData.fromJson (Map<String,dynamic> json){
    // double currTime = json["list"]["dt"];
    // double sunsetTime = json["list"]["sunset"];

  return WeatherData(
    temp: Temperature(defaultTemperature: json["main"]["temp"]),
    minTemp: Temperature(defaultTemperature:json["main"]["temp_min"]),
    maxTemp: Temperature(defaultTemperature:json["main"]["temp_max"]),
    weatherInfo: json["weather"][0],
    iconUrl: "https://openweathermap.org/img/wn/${json["weather"][0]["icon"]}.png",
  );
  }




}
class Temperature{
  final double defaultTemperature;
  Temperature({required this.defaultTemperature});
  double get celsius => defaultTemperature;
  double get farenheight => defaultTemperature*9/5 + 32;


  
}
