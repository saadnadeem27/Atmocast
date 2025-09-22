import 'package:flutter/foundation.dart';

import '../data/models/weather_data.dart';
import '../data/models/forecast.dart';
import '../data/models/location.dart';
import '../data/services/dummy_weather_service.dart';
import '../data/services/dummy_location_service.dart';

enum WeatherStatus {
  initial,
  loading,
  success,
  error,
}

class WeatherProvider extends ChangeNotifier {
  final DummyWeatherService _weatherApiService;
  final DummyLocationService _locationService;

  // State
  WeatherStatus _status = WeatherStatus.initial;
  WeatherData? _currentWeather;
  List<HourlyForecast> _hourlyForecast = [];
  List<DailyForecast> _dailyForecast = [];
  Location? _currentLocation;
  String? _errorMessage;
  DateTime? _lastUpdated;

  // Search state
  List<Location> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;

  WeatherProvider({
    DummyWeatherService? weatherApiService,
    DummyLocationService? locationService,
  })  : _weatherApiService = weatherApiService ?? DummyWeatherService(),
        _locationService = locationService ?? DummyLocationService();

  // Getters
  WeatherStatus get status => _status;
  WeatherData? get currentWeather => _currentWeather;
  List<HourlyForecast> get hourlyForecast => List.unmodifiable(_hourlyForecast);
  List<DailyForecast> get dailyForecast => List.unmodifiable(_dailyForecast);
  Location? get currentLocation => _currentLocation;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;

  List<Location> get searchResults => List.unmodifiable(_searchResults);
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;

  bool get hasData => _currentWeather != null;
  bool get isLoading => _status == WeatherStatus.loading;
  bool get hasError => _status == WeatherStatus.error;

  /// Initialize weather provider with current location
  Future<void> initialize() async {
    try {
      _setStatus(WeatherStatus.loading);
      debugPrint('WeatherProvider: Starting initialization...');

      // Get current location
      final location = await _locationService.getLocationWithFallback();
      debugPrint(
          'WeatherProvider: Got location: ${location.name} (${location.latitude}, ${location.longitude})');

      await loadWeatherForLocation(location);
      debugPrint('WeatherProvider: Initialization completed successfully');
    } catch (e) {
      debugPrint('WeatherProvider: Initialization failed: $e');
      _setError('Failed to initialize weather data: ${e.toString()}');
    }
  }

  /// Load weather data for a specific location
  Future<void> loadWeatherForLocation(Location location) async {
    try {
      _setStatus(WeatherStatus.loading);
      _currentLocation = location;
      debugPrint(
          'WeatherProvider: Loading weather for location: ${location.name}');

      // Get comprehensive weather data
      final weatherData =
          await _weatherApiService.getComprehensiveWeatherData(location);

      _currentWeather = weatherData['current'] as WeatherData;
      _hourlyForecast = weatherData['hourly'] as List<HourlyForecast>;
      _dailyForecast = weatherData['daily'] as List<DailyForecast>;
      _lastUpdated = DateTime.now();

      debugPrint('WeatherProvider: Weather data loaded successfully');
      debugPrint(
          'WeatherProvider: Current temp: ${_currentWeather?.temperature.current}°C');
      debugPrint(
          'WeatherProvider: Hourly forecasts: ${_hourlyForecast.length}');
      debugPrint('WeatherProvider: Daily forecasts: ${_dailyForecast.length}');

      _setStatus(WeatherStatus.success);
    } catch (e) {
      debugPrint('WeatherProvider: Failed to load weather data: $e');
      _setError('Failed to load weather data: ${e.toString()}');
    }
  }

  /// Refresh current weather data
  Future<void> refreshWeatherData() async {
    if (_currentLocation == null) {
      await initialize();
      return;
    }

    await loadWeatherForLocation(_currentLocation!);
  }

  /// Update location and load weather data
  Future<void> updateLocation(Location location) async {
    if (_currentLocation != null &&
        _currentLocation!.latitude == location.latitude &&
        _currentLocation!.longitude == location.longitude) {
      return; // Same location, no need to update
    }

    await loadWeatherForLocation(location);
  }

  /// Get current location and load weather data
  Future<void> loadCurrentLocationWeather() async {
    try {
      _setStatus(WeatherStatus.loading);

      final location = await _locationService.getCurrentLocation();

      // Get location name using reverse geocoding
      final locationWithName =
          await _weatherApiService.getLocationByCoordinates(
        location.latitude,
        location.longitude,
      );

      await loadWeatherForLocation(locationWithName);
    } catch (e) {
      _setError('Failed to get current location weather: ${e.toString()}');
    }
  }

  /// Search for cities
  Future<void> searchCities(String query) async {
    if (query.trim().isEmpty) {
      _searchResults.clear();
      _searchError = null;
      _isSearching = false;
      notifyListeners();
      return;
    }

    try {
      _isSearching = true;
      _searchError = null;
      notifyListeners();

      _searchResults = await _locationService.searchCities(query);
    } catch (e) {
      _searchError = 'Failed to search cities: ${e.toString()}';
      _searchResults.clear();
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Clear search results
  void clearSearch() {
    _searchResults.clear();
    _searchError = null;
    _isSearching = false;
    notifyListeners();
  }

  /// Get weather for multiple locations (for saved locations)
  Future<List<WeatherData>> getWeatherForLocations(
      List<Location> locations) async {
    final weatherDataList = <WeatherData>[];

    try {
      for (final location in locations) {
        try {
          final weather = await _weatherApiService.getCurrentWeather(location);
          weatherDataList.add(weather);
        } catch (e) {
          debugPrint('Failed to get weather for ${location.name}: $e');
        }
      }
    } catch (e) {
      debugPrint('Failed to get weather for multiple locations: $e');
    }

    return weatherDataList;
  }

  /// Check if weather data is fresh
  bool get isDataFresh {
    if (_lastUpdated == null || _currentWeather == null) return false;

    final now = DateTime.now();
    final difference = now.difference(_lastUpdated!);
    return difference.inMinutes < 10; // Consider data fresh for 10 minutes
  }

  /// Get next hour forecast
  HourlyForecast? get nextHourForecast {
    if (_hourlyForecast.isEmpty) return null;

    final now = DateTime.now();
    return _hourlyForecast.firstWhere(
      (forecast) => forecast.dateTime.isAfter(now),
      orElse: () => _hourlyForecast.first,
    );
  }

  /// Get today's forecast
  DailyForecast? get todayForecast {
    if (_dailyForecast.isEmpty) return null;

    final today = DateTime.now();
    return _dailyForecast.firstWhere(
      (forecast) =>
          forecast.date.day == today.day &&
          forecast.date.month == today.month &&
          forecast.date.year == today.year,
      orElse: () => _dailyForecast.first,
    );
  }

  /// Get tomorrow's forecast
  DailyForecast? get tomorrowForecast {
    if (_dailyForecast.length < 2) return null;
    return _dailyForecast[1];
  }

  /// Get hourly forecast for next 24 hours
  List<HourlyForecast> get next24HoursForecast {
    if (_hourlyForecast.isEmpty) return [];

    final now = DateTime.now();
    final next24Hours = now.add(const Duration(hours: 24));

    return _hourlyForecast
        .where((forecast) =>
            forecast.dateTime.isAfter(now) &&
            forecast.dateTime.isBefore(next24Hours))
        .toList();
  }

  /// Get weather condition color based on current weather
  String get currentWeatherColor {
    if (_currentWeather == null) return '#2196F3';

    return _getWeatherColor(_currentWeather!.primaryCondition.main);
  }

  String _getWeatherColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return '#FFD700';
      case 'clouds':
        return '#87CEEB';
      case 'rain':
      case 'drizzle':
        return '#4682B4';
      case 'thunderstorm':
        return '#483D8B';
      case 'snow':
        return '#F0F8FF';
      case 'mist':
      case 'fog':
        return '#B0C4DE';
      default:
        return '#2196F3';
    }
  }

  void _setStatus(WeatherStatus status) {
    _status = status;
    if (status != WeatherStatus.error) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _status = WeatherStatus.error;
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    _weatherApiService.dispose();
    super.dispose();
  }
}
