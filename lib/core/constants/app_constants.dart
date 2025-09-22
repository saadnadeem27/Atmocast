class AppConstants {
  // API Configuration
  static const String weatherApiKey = 'API KEY'; // Demo API key
  static const String weatherBaseUrl =
      'https://api.openweathermap.org/data/2.5';
  static const String geocodingBaseUrl =
      'https://api.openweathermap.org/geo/1.0';
  static const String weatherIconUrl = 'https://openweathermap.org/img/wn';

  // App Configuration
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration refreshInterval = Duration(minutes: 10);
  static const int cacheExpirationMinutes = 15; // Cache expiration in minutes

  // Local Storage Keys
  static const String keySelectedCities = 'selected_cities';
  static const String keyCurrentLocation = 'current_location';
  static const String keyTemperatureUnit = 'temperature_unit';
  static const String keyWindSpeedUnit = 'wind_speed_unit';
  static const String keyPressureUnit = 'pressure_unit';
  static const String keyDistanceUnit = 'distance_unit';
  static const String keyTimeFormat = 'time_format';
  static const String keyDarkMode = 'dark_mode';
  static const String keyNotifications = 'notifications';
  static const String keyAutoLocation = 'auto_location';
  static const String keyLanguage = 'language';
  static const String keyLastWeatherUpdate = 'last_weather_update';
  static const String keyWeatherCache = 'weather_cache';

  // Default Values
  static const String defaultTemperatureUnit =
      'metric'; // metric, imperial, kelvin
  static const String defaultWindSpeedUnit = 'kmh'; // kmh, mph, ms
  static const String defaultPressureUnit = 'hPa'; // hPa, inHg
  static const String defaultDistanceUnit = 'km'; // km, miles
  static const String defaultTimeFormat = '24h'; // 24h, 12h
  static const bool defaultDarkMode = true;
  static const bool defaultNotifications = true;
  static const bool defaultAutoLocation = true;
  static const String defaultLanguage = 'en';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double extraLargePadding = 32.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;
  static const double extraLargeBorderRadius = 24.0;

  static const double cardElevation = 0.0;
  static const double appBarElevation = 0.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);
  static const Duration extraLongAnimation = Duration(milliseconds: 800);

  // Screen Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;

  // Weather Icons Mapping
  static const Map<String, String> weatherIcons = {
    '01d': '☀️', // clear sky day
    '01n': '🌙', // clear sky night
    '02d': '⛅', // few clouds day
    '02n': '☁️', // few clouds night
    '03d': '☁️', // scattered clouds day
    '03n': '☁️', // scattered clouds night
    '04d': '☁️', // broken clouds day
    '04n': '☁️', // broken clouds night
    '09d': '🌧️', // shower rain day
    '09n': '🌧️', // shower rain night
    '10d': '🌦️', // rain day
    '10n': '🌧️', // rain night
    '11d': '⛈️', // thunderstorm day
    '11n': '⛈️', // thunderstorm night
    '13d': '❄️', // snow day
    '13n': '❄️', // snow night
    '50d': '🌫️', // mist day
    '50n': '🌫️', // mist night
  };

  // Weather Condition Colors
  static const Map<String, String> weatherConditionColors = {
    'clear': '#FFD700',
    'clouds': '#87CEEB',
    'rain': '#4682B4',
    'drizzle': '#87CEFA',
    'thunderstorm': '#483D8B',
    'snow': '#F0F8FF',
    'mist': '#B0C4DE',
    'smoke': '#696969',
    'haze': '#D3D3D3',
    'dust': '#DEB887',
    'fog': '#708090',
    'sand': '#F4A460',
    'ash': '#A9A9A9',
    'squall': '#2F4F4F',
    'tornado': '#8B0000',
  };

  // Units Conversion
  static const Map<String, double> temperatureConversion = {
    'celsius_to_fahrenheit': 1.8, // (C * 1.8) + 32
    'fahrenheit_to_celsius': 0.5556, // (F - 32) * 0.5556
    'celsius_to_kelvin': 273.15, // C + 273.15
    'kelvin_to_celsius': -273.15, // K - 273.15
  };

  static const Map<String, double> windSpeedConversion = {
    'ms_to_kmh': 3.6,
    'ms_to_mph': 2.237,
    'kmh_to_ms': 0.2778,
    'kmh_to_mph': 0.6214,
    'mph_to_ms': 0.4470,
    'mph_to_kmh': 1.609,
  };

  static const Map<String, double> pressureConversion = {
    'hpa_to_inhg': 0.02953,
    'inhg_to_hpa': 33.864,
  };

  static const Map<String, double> distanceConversion = {
    'km_to_miles': 0.6214,
    'miles_to_km': 1.609,
    'm_to_ft': 3.281,
    'ft_to_m': 0.3048,
  };

  // Location Constants
  static const double defaultLatitude = 40.7128; // New York
  static const double defaultLongitude = -74.0060; // New York
  static const double locationAccuracy = 100.0; // meters
  static const Duration locationTimeout = Duration(seconds: 15);

  // Cache Constants
  static const Duration cacheExpiration = Duration(hours: 1);
  static const int maxCachedLocations = 10;
  static const int maxSearchResults = 5;

  // Error Messages
  static const String errorGeneric = 'Something went wrong. Please try again.';
  static const String errorNetwork =
      'No internet connection. Please check your network.';
  static const String errorLocation =
      'Unable to get your location. Please enable location services.';
  static const String errorPermission =
      'Location permission is required to get weather data.';
  static const String errorApiKey =
      'Invalid API key. Please check your configuration.';
  static const String errorApiLimit =
      'API limit reached. Please try again later.';
  static const String errorCityNotFound =
      'City not found. Please try a different search term.';

  // Success Messages
  static const String successLocationUpdated = 'Location updated successfully';
  static const String successWeatherRefreshed = 'Weather data refreshed';
  static const String successSettingsSaved = 'Settings saved successfully';
}
