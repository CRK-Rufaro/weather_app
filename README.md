//Rufaro
Open weather has updated its API, geolocating is now done independantly of fetching weather & forecasts, the project files have been updated to match that.
The application has been unit and widget tested.
The application is now responsive, dynamically adjusting to fit different screen sizes and orientations.
The codemagic.yaml file includes a workflow that builds a simulator IOS app bundle.
(Critical NB: An environment variable called API_KEY of the group API_KEYS needs to created for a .env to be dynamically generated during the codemagic build process).

This app bundle can be uploaded and used on appertise.io (https://appetize.io/) or similar services to test or view the application online.

Similarly on a local machine, .env file with the apikey in the format
WEATHER_API_KEY = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";

Needs to be present in the root directory of the project for the application to run.

To obtain an API KEY 
visit: https://openweathermap.org
//


This is a weather application that allows you to search an areas weather forecast.

This app will give the current weather data as well as a forecast.

You will need to get this app to compile on android, IOS and web. There are Todos in the code that will help
guide you to get there.

The forecast component has not been built yet, so please add this functional requirement as well. The assets that are required have already been included.
Here below are the designs for what the forecast should look like:

![alt text](https://raw.githubusercontent.com/Johan-glitch1412/weather_app/main/.github/images/Screenshot%202024-04-16%20at%2013.27.53.png "Logo Title Text 1")

This code needs to be unit and widget tested as well to ensure that if any changes are made that those tests would pick it up and report the errors.

This application uses Provider for state management and an http handler has been built to control all of the API calls.

#Bonus:
Swap from celsius to fahrenheit

