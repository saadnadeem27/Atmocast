class AppStrings {
  // App Info
  static const String appName = 'Atmocast';
  static const String appSlogan = 'Your Premium Weather Companion';

  // Weather Conditions
  static const String clear = 'Clear';
  static const String clouds = 'Clouds';
  static const String rain = 'Rain';
  static const String drizzle = 'Drizzle';
  static const String thunderstorm = 'Thunderstorm';
  static const String snow = 'Snow';
  static const String mist = 'Mist';
  static const String smoke = 'Smoke';
  static const String haze = 'Haze';
  static const String dust = 'Dust';
  static const String fog = 'Fog';
  static const String sand = 'Sand';
  static const String ash = 'Ash';
  static const String squall = 'Squall';
  static const String tornado = 'Tornado';

  // Weather Details
  static const String temperature = 'Temperature';
  static const String feelsLike = 'Feels like';
  static const String humidity = 'Humidity';
  static const String windSpeed = 'Wind Speed';
  static const String windDirection = 'Wind Direction';
  static const String pressure = 'Pressure';
  static const String visibility = 'Visibility';
  static const String uvIndex = 'UV Index';
  static const String sunrise = 'Sunrise';
  static const String sunset = 'Sunset';
  static const String cloudCover = 'Cloud Cover';
  static const String dewPoint = 'Dew Point';

  // Forecast
  static const String hourlyForecast = 'Hourly Forecast';
  static const String dailyForecast = '7-Day Forecast';
  static const String today = 'Today';
  static const String tomorrow = 'Tomorrow';

  // Actions
  static const String search = 'Search';
  static const String searchLocation = 'Search for a city...';
  static const String currentLocation = 'Current Location';
  static const String addLocation = 'Add Location';
  static const String removeLocation = 'Remove Location';
  static const String refresh = 'Refresh';
  static const String settings = 'Settings';
  static const String about = 'About';

  // Units
  static const String celsius = '°C';
  static const String fahrenheit = '°F';
  static const String kelvin = 'K';
  static const String kmh = 'km/h';
  static const String mph = 'mph';
  static const String ms = 'm/s';
  static const String hPa = 'hPa';
  static const String inHg = 'inHg';
  static const String km = 'km';
  static const String miles = 'miles';
  static const String percent = '%';

  // Messages
  static const String loading = 'Loading...';
  static const String noData = 'No data available';
  static const String errorOccurred = 'An error occurred';
  static const String noInternet = 'No internet connection';
  static const String locationPermissionDenied = 'Location permission denied';
  static const String locationServiceDisabled = 'Location service disabled';
  static const String searchResultsEmpty = 'No cities found';
  static const String weatherDataUnavailable = 'Weather data unavailable';

  // Settings
  static const String temperatureUnit = 'Temperature Unit';
  static const String windSpeedUnit = 'Wind Speed Unit';
  static const String pressureUnit = 'Pressure Unit';
  static const String distanceUnit = 'Distance Unit';
  static const String timeFormat = 'Time Format';
  static const String darkMode = 'Dark Mode';
  static const String notifications = 'Notifications';
  static const String autoLocation = 'Auto Location';
  static const String language = 'Language';

  // Time
  static const String am = 'AM';
  static const String pm = 'PM';
  static const String now = 'Now';
  static const String minutesAgo = 'minutes ago';
  static const String hoursAgo = 'hours ago';
  static const String lastUpdated = 'Last updated';

  // Days of week
  static const List<String> daysShort = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat'
  ];

  static const List<String> daysLong = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday'
  ];

  // Months
  static const List<String> monthsShort = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  static const List<String> monthsLong = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // Weather Descriptions
  static const Map<String, String> weatherDescriptions = {
    'clear sky': 'Clear skies with bright sunshine',
    'few clouds': 'Mostly sunny with a few clouds',
    'scattered clouds': 'Partly cloudy with scattered clouds',
    'broken clouds': 'Mostly cloudy conditions',
    'overcast clouds': 'Completely overcast sky',
    'light rain': 'Light rain showers',
    'moderate rain': 'Moderate rainfall',
    'heavy rain': 'Heavy rain expected',
    'light snow': 'Light snowfall',
    'heavy snow': 'Heavy snow conditions',
    'thunderstorm': 'Thunderstorms in the area',
    'mist': 'Misty conditions with reduced visibility',
    'fog': 'Foggy conditions with low visibility',
  };
}
