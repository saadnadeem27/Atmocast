import 'dart:async';
import 'dart:math';

import '../models/weather_data.dart';
import '../models/forecast.dart';
import '../models/location.dart';
import '../models/weather_condition.dart';
import '../models/temperature.dart';
import '../models/wind.dart';

class DummyWeatherService {
  final Random _random = Random();

  /// Get dummy current weather data
  Future<WeatherData> getCurrentWeather(Location location) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    final conditions = [
      'Clear',
      'Clouds',
      'Rain',
      'Snow',
      'Thunderstorm',
      'Mist'
    ];

    final condition = conditions[_random.nextInt(conditions.length)];
    final isDay = DateTime.now().hour >= 6 && DateTime.now().hour < 18;
    final temp = 15 + _random.nextInt(20); // 15-35°C

    return WeatherData(
      location: location,
      dateTime: DateTime.now(),
      conditions: [WeatherCondition(
        id: 800,
        main: condition,
        description: _getDescription(condition),
        icon: _getIcon(condition, isDay),
      )],
      temperature: Temperature(
        current: temp.toDouble(),
        feelsLike: temp + _random.nextInt(5) - 2.0,
        min: temp - _random.nextInt(5).toDouble(),
        max: temp + _random.nextInt(8).toDouble(),
      ),
      humidity: (40 + _random.nextInt(40)).toDouble(), // 40-80%
      pressure: (1000 + _random.nextInt(50)).toDouble(), // 1000-1050 hPa
      visibility: (5 + _random.nextInt(15)).toDouble(), // 5-20 km
      uvIndex: _random.nextInt(11).toDouble(), // 0-10
      wind: Wind(
        speed: _random.nextInt(20).toDouble(), // 0-20 m/s
        direction: _random.nextInt(360), // 0-359°
        gust: _random.nextInt(30).toDouble(),
      ),
      cloudCover: _random.nextInt(100), // 0-100%
      sunrise: DateTime.now().copyWith(hour: 6, minute: 30),
      sunset: DateTime.now().copyWith(hour: 18, minute: 45),
    );
  }

  /// Get dummy hourly forecast (next 24 hours)
  Future<List<HourlyForecast>> getHourlyForecast(Location location) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final forecasts = <HourlyForecast>[];
    final now = DateTime.now();

    for (int i = 0; i < 24; i++) {
      final time = now.add(Duration(hours: i));
      final isDay = time.hour >= 6 && time.hour < 18;
      final baseTemp = 20 + _random.nextInt(15);
      
      // Temperature varies throughout the day
      final hourTemp = baseTemp + 
          (isDay ? _random.nextInt(8) : -_random.nextInt(5));

      final conditions = ['Clear', 'Clouds', 'Rain'];
      final condition = conditions[_random.nextInt(conditions.length)];

      forecasts.add(HourlyForecast(
        dateTime: time,
        temperature: Temperature(
          current: hourTemp.toDouble(),
          feelsLike: hourTemp + _random.nextInt(3) - 1.0,
          min: hourTemp - 2.0,
          max: hourTemp + 2.0,
        ),
        conditions: [WeatherCondition(
          id: 800,
          main: condition,
          description: _getDescription(condition),
          icon: _getIcon(condition, isDay),
        )],
        wind: Wind(
          speed: _random.nextInt(15).toDouble(),
          direction: _random.nextInt(360),
          gust: _random.nextInt(20).toDouble(),
        ),
        humidity: (40 + _random.nextInt(40)).toDouble(),
        pressure: (1000 + _random.nextInt(30)).toDouble(),
        uvIndex: isDay ? _random.nextInt(11).toDouble() : 0,
        cloudCover: _random.nextInt(100),
        precipitation: condition == 'Rain' ? _random.nextInt(5).toDouble() : null,
        precipitationProbability: condition == 'Rain' ? (_random.nextInt(50) + 20) / 100.0 : null,
      ));
    }

    return forecasts;
  }

  /// Get dummy daily forecast (next 7 days)
  Future<List<DailyForecast>> getDailyForecast(Location location) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final forecasts = <DailyForecast>[];
    final now = DateTime.now();

    for (int i = 1; i <= 7; i++) {
      final date = now.add(Duration(days: i));
      final baseTemp = 18 + _random.nextInt(12);
      
      final conditions = ['Clear', 'Clouds', 'Rain', 'Snow'];
      final condition = conditions[_random.nextInt(conditions.length)];

      forecasts.add(DailyForecast(
        date: date,
        temperature: Temperature(
          current: baseTemp.toDouble(),
          feelsLike: baseTemp.toDouble(),
          min: (baseTemp - _random.nextInt(8)).toDouble(),
          max: (baseTemp + _random.nextInt(12)).toDouble(),
        ),
        conditions: [WeatherCondition(
          id: 800,
          main: condition,
          description: _getDescription(condition),
          icon: _getIcon(condition, true),
        )],
        wind: Wind(
          speed: _random.nextInt(20).toDouble(),
          direction: _random.nextInt(360),
          gust: _random.nextInt(25).toDouble(),
        ),
        humidity: (35 + _random.nextInt(50)).toDouble(),
        pressure: (1000 + _random.nextInt(40)).toDouble(),
        uvIndex: _random.nextInt(11).toDouble(),
        cloudCover: _random.nextInt(100),
        precipitation: condition == 'Rain' ? _random.nextInt(10).toDouble() : null,
        precipitationProbability: condition == 'Rain' ? (_random.nextInt(60) + 20) / 100.0 : null,
        sunrise: date.copyWith(hour: 6, minute: 30 + _random.nextInt(30)),
        sunset: date.copyWith(hour: 18, minute: 30 + _random.nextInt(60)),
      ));
    }

    return forecasts;
  }

  /// Get comprehensive dummy weather data
  Future<Map<String, dynamic>> getComprehensiveWeatherData(Location location) async {
    final results = await Future.wait([
      getCurrentWeather(location),
      getHourlyForecast(location),
      getDailyForecast(location),
    ]);

    return {
      'current': results[0] as WeatherData,
      'hourly': results[1] as List<HourlyForecast>,
      'daily': results[2] as List<DailyForecast>,
    };
  }

  /// Search for dummy cities
  Future<List<Location>> searchCities(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (query.trim().isEmpty) return [];

    final cities = [
      Location(name: 'New York', country: 'US', latitude: 40.7128, longitude: -74.0060),
      Location(name: 'London', country: 'GB', latitude: 51.5074, longitude: -0.1278),
      Location(name: 'Tokyo', country: 'JP', latitude: 35.6762, longitude: 139.6503),
      Location(name: 'Paris', country: 'FR', latitude: 48.8566, longitude: 2.3522),
      Location(name: 'Sydney', country: 'AU', latitude: -33.8688, longitude: 151.2093),
      Location(name: 'Dubai', country: 'AE', latitude: 25.2048, longitude: 55.2708),
      Location(name: 'Los Angeles', country: 'US', latitude: 34.0522, longitude: -118.2437),
      Location(name: 'Berlin', country: 'DE', latitude: 52.5200, longitude: 13.4050),
      Location(name: 'Singapore', country: 'SG', latitude: 1.3521, longitude: 103.8198),
      Location(name: 'Mumbai', country: 'IN', latitude: 19.0760, longitude: 72.8777),
    ];

    // Filter cities based on query
    final filteredCities = cities
        .where((city) => 
            city.name.toLowerCase().contains(query.toLowerCase()) ||
            city.country.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();

    return filteredCities;
  }

  /// Get location by coordinates (dummy reverse geocoding)
  Future<Location> getLocationByCoordinates(double latitude, double longitude) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Return a dummy location based on coordinates
    return Location(
      name: 'Current Location',
      country: 'Local',
      latitude: latitude,
      longitude: longitude,
      isCurrentLocation: true,
    );
  }

  String _getDescription(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'Clear sky';
      case 'clouds':
        return 'Partly cloudy';
      case 'rain':
        return 'Light rain';
      case 'snow':
        return 'Light snow';
      case 'thunderstorm':
        return 'Thunderstorm';
      case 'mist':
        return 'Misty';
      default:
        return 'Weather condition';
    }
  }

  String _getIcon(String condition, bool isDay) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return isDay ? '01d' : '01n';
      case 'clouds':
        return isDay ? '02d' : '02n';
      case 'rain':
        return isDay ? '10d' : '10n';
      case 'snow':
        return '13d';
      case 'thunderstorm':
        return '11d';
      case 'mist':
        return '50d';
      default:
        return isDay ? '01d' : '01n';
    }
  }

  /// Dispose method for compatibility
  void dispose() {
    // Nothing to dispose for dummy service
  }
}