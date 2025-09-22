import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/weather_data.dart';
import '../models/forecast.dart';
import '../models/location.dart';
import '../../core/constants/app_constants.dart';

class WeatherApiException implements Exception {
  final String message;
  final int? statusCode;

  const WeatherApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'WeatherApiException: $message';
}

class CacheEntry<T> {
  final T data;
  final DateTime timestamp;

  CacheEntry(this.data, this.timestamp);

  bool get isExpired {
    final now = DateTime.now();
    return now.difference(timestamp).inMinutes >
        AppConstants.cacheExpirationMinutes;
  }
}

class WeatherApiService {
  static const String _apiKey = AppConstants.weatherApiKey;
  static const String _baseUrl = AppConstants.weatherBaseUrl;
  static const String _geocodingUrl = AppConstants.geocodingBaseUrl;

  final http.Client _client;

  // Simple cache for API responses (in memory only)
  final Map<String, CacheEntry<WeatherData>> _weatherCache = {};
  final Map<String, CacheEntry<List<Location>>> _searchCache = {};

  WeatherApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Get current weather data for a location
  Future<WeatherData> getCurrentWeather(Location location) async {
    // Create cache key
    final cacheKey = '${location.latitude},${location.longitude}';

    // Check cache first
    final cached = _weatherCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      debugPrint('WeatherApi: Using cached weather data for ${location.name}');
      return cached.data;
    }

    try {
      debugPrint(
          'WeatherApi: Fetching weather data for ${location.name} (${location.latitude}, ${location.longitude})');

      final uri = Uri.parse('$_baseUrl/weather').replace(queryParameters: {
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
        'appid': _apiKey,
        'units': 'metric',
      });

      debugPrint('WeatherApi: Request URL: $uri');

      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      debugPrint('WeatherApi: Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final weatherData = WeatherData.fromJson(data, location);

        // Cache the result
        _weatherCache[cacheKey] = CacheEntry(weatherData, DateTime.now());

        debugPrint('WeatherApi: Weather data fetched successfully');
        return weatherData;
      } else {
        debugPrint(
            'WeatherApi: API error - Status: ${response.statusCode}, Body: ${response.body}');
        throw WeatherApiException(
          _getErrorMessage(response.statusCode, response.body),
          response.statusCode,
        );
      }
    } on SocketException catch (e) {
      debugPrint('WeatherApi: Network error - SocketException: $e');
      throw const WeatherApiException(AppConstants.errorNetwork);
    } on HttpException catch (e) {
      debugPrint('WeatherApi: Network error - HttpException: $e');
      throw const WeatherApiException(AppConstants.errorNetwork);
    } catch (e) {
      debugPrint('WeatherApi: Unknown error: $e');
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException(
          'Failed to fetch weather data: ${e.toString()}');
    }
  }

  /// Get hourly forecast for a location (48 hours)
  Future<List<HourlyForecast>> getHourlyForecast(Location location) async {
    try {
      final uri = Uri.parse('$_baseUrl/forecast').replace(queryParameters: {
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
        'appid': _apiKey,
        'units': 'metric',
      });

      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> list = data['list'] ?? [];

        return list
            .take(40) // 5-day forecast with 3-hour intervals (40 items)
            .map((item) => HourlyForecast.fromJson(item))
            .toList();
      } else {
        throw WeatherApiException(
          _getErrorMessage(response.statusCode, response.body),
          response.statusCode,
        );
      }
    } on SocketException {
      throw const WeatherApiException(AppConstants.errorNetwork);
    } on HttpException {
      throw const WeatherApiException(AppConstants.errorNetwork);
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException(
          'Failed to fetch hourly forecast: ${e.toString()}');
    }
  }

  /// Get daily forecast for a location (5 days) using free API
  Future<List<DailyForecast>> getDailyForecast(Location location) async {
    try {
      final uri = Uri.parse('$_baseUrl/forecast').replace(queryParameters: {
        'lat': location.latitude.toString(),
        'lon': location.longitude.toString(),
        'appid': _apiKey,
        'units': 'metric',
      });

      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> forecastList = data['list'] ?? [];

        // Group forecasts by day
        final Map<String, List<dynamic>> dailyData = {};
        for (final item in forecastList) {
          final DateTime date = DateTime.fromMillisecondsSinceEpoch(
            (item['dt'] as int) * 1000,
          );
          final String dayKey =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

          if (!dailyData.containsKey(dayKey)) {
            dailyData[dayKey] = [];
          }
          dailyData[dayKey]!.add(item);
        }

        // Convert to DailyForecast objects
        final List<DailyForecast> dailyForecasts = [];
        for (final entry in dailyData.entries) {
          if (dailyForecasts.length >= 5) break; // Limit to 5 days

          final dayData = entry.value;
          if (dayData.isNotEmpty) {
            // Use midday forecast for daily summary
            final midDayForecast = dayData.length > 1
                ? dayData[dayData.length ~/ 2]
                : dayData.first;
            dailyForecasts.add(DailyForecast.fromJson(midDayForecast));
          }
        }

        return dailyForecasts;
      } else {
        throw WeatherApiException(
          _getErrorMessage(response.statusCode, response.body),
          response.statusCode,
        );
      }
    } on SocketException {
      throw const WeatherApiException(AppConstants.errorNetwork);
    } on HttpException {
      throw const WeatherApiException(AppConstants.errorNetwork);
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException(
          'Failed to fetch daily forecast: ${e.toString()}');
    }
  }

  /// Search for cities by name
  Future<List<Location>> searchCities(String query) async {
    if (query.trim().isEmpty) return [];

    // Create cache key for search
    final cacheKey = query.trim().toLowerCase();

    // Check cache first
    final cached = _searchCache[cacheKey];
    if (cached != null && !cached.isExpired) {
      return cached.data;
    }

    try {
      final uri = Uri.parse('$_geocodingUrl/direct').replace(queryParameters: {
        'q': query.trim(),
        'limit': AppConstants.maxSearchResults.toString(),
        'appid': _apiKey,
      });

      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final locations = data.map((item) => Location.fromJson(item)).toList();

        // Cache the search results
        _searchCache[cacheKey] = CacheEntry(locations, DateTime.now());

        return locations;
      } else {
        throw WeatherApiException(
          _getErrorMessage(response.statusCode, response.body),
          response.statusCode,
        );
      }
    } on SocketException {
      throw const WeatherApiException(AppConstants.errorNetwork);
    } on HttpException {
      throw const WeatherApiException(AppConstants.errorNetwork);
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Failed to search cities: ${e.toString()}');
    }
  }

  /// Get location by coordinates (reverse geocoding)
  Future<Location> getLocationByCoordinates(
      double latitude, double longitude) async {
    try {
      final uri = Uri.parse('$_geocodingUrl/reverse').replace(queryParameters: {
        'lat': latitude.toString(),
        'lon': longitude.toString(),
        'limit': '1',
        'appid': _apiKey,
      });

      final response = await _client.get(uri).timeout(AppConstants.apiTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return Location.fromJson(data.first).copyWith(
            latitude: latitude,
            longitude: longitude,
            isCurrentLocation: true,
          );
        } else {
          // Fallback to default location data
          return Location(
            name: 'Unknown Location',
            country: 'Unknown',
            latitude: latitude,
            longitude: longitude,
            isCurrentLocation: true,
          );
        }
      } else {
        throw WeatherApiException(
          _getErrorMessage(response.statusCode, response.body),
          response.statusCode,
        );
      }
    } on SocketException {
      throw const WeatherApiException(AppConstants.errorNetwork);
    } on HttpException {
      throw const WeatherApiException(AppConstants.errorNetwork);
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException('Failed to get location: ${e.toString()}');
    }
  }

  /// Get comprehensive weather data (current + forecasts)
  Future<Map<String, dynamic>> getComprehensiveWeatherData(
      Location location) async {
    try {
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
    } catch (e) {
      if (e is WeatherApiException) rethrow;
      throw WeatherApiException(
          'Failed to get comprehensive weather data: ${e.toString()}');
    }
  }

  /// Check if API key is valid
  Future<bool> validateApiKey() async {
    try {
      final uri = Uri.parse('$_baseUrl/weather').replace(queryParameters: {
        'lat': AppConstants.defaultLatitude.toString(),
        'lon': AppConstants.defaultLongitude.toString(),
        'appid': _apiKey,
      });

      final response = await _client.get(uri).timeout(
            const Duration(seconds: 10),
          );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  String _getErrorMessage(int statusCode, String responseBody) {
    switch (statusCode) {
      case 401:
        return AppConstants.errorApiKey;
      case 429:
        return AppConstants.errorApiLimit;
      case 404:
        return AppConstants.errorCityNotFound;
      case 500:
      case 502:
      case 503:
      case 504:
        return 'Server error. Please try again later.';
      default:
        try {
          final data = json.decode(responseBody);
          return data['message'] ?? AppConstants.errorGeneric;
        } catch (e) {
          return AppConstants.errorGeneric;
        }
    }
  }

  void dispose() {
    _client.close();
  }
}
