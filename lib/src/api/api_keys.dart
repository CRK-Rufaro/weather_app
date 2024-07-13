import 'package:get_it/get_it.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// To get an API key, sign up here:
/// https://home.openweathermap.org/users/sign_up
///

final sl = GetIt.instance;

void setupInjection() {
  //TODO setup injection using 'api_key' instance name. Refer to https://pub.dev/packages/get_it for documentation


  sl.registerSingleton<String>('${dotenv.env['WEATHER_API_KEY']}', instanceName: 'api_key');
}
