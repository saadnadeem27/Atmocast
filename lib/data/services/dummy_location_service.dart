import 'dart:async';
import 'dart:math';

import '../models/location.dart';

class DummyLocationService {
  final Random _random = Random();

  /// Get dummy current location
  Future<Location> getCurrentLocation() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return a random demo location
    final demoLocations = [
      Location(name: 'San Francisco', country: 'US', latitude: 37.7749, longitude: -122.4194, isCurrentLocation: true),
      Location(name: 'London', country: 'GB', latitude: 51.5074, longitude: -0.1278, isCurrentLocation: true),
      Location(name: 'Tokyo', country: 'JP', latitude: 35.6762, longitude: 139.6503, isCurrentLocation: true),
      Location(name: 'Sydney', country: 'AU', latitude: -33.8688, longitude: 151.2093, isCurrentLocation: true),
      Location(name: 'New York', country: 'US', latitude: 40.7128, longitude: -74.0060, isCurrentLocation: true),
    ];

    return demoLocations[_random.nextInt(demoLocations.length)];
  }

  /// Get dummy location with fallback
  Future<Location> getLocationWithFallback() async {
    return await getCurrentLocation();
  }

  /// Get dummy last known location
  Future<Location?> getLastKnownLocation() async {
    return await getCurrentLocation();
  }

  /// Check if location services are enabled (always true for demo)
  Future<bool> isLocationServiceEnabled() async {
    return true;
  }

  /// Get location by coordinates (dummy reverse geocoding)
  Future<Location> getLocationByCoordinates(double latitude, double longitude) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return Location(
      name: 'Demo Location',
      country: 'Demo',
      latitude: latitude,
      longitude: longitude,
      isCurrentLocation: true,
    );
  }

  /// Search for locations (using dummy data)
  Future<List<Location>> searchLocation(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

    if (query.trim().isEmpty) return [];

    return await searchCities(query);
  }

  /// Search for cities (alias method for consistency)
  Future<List<Location>> searchCities(String query) async {
    await Future.delayed(const Duration(milliseconds: 400));

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
      Location(name: 'Cairo', country: 'EG', latitude: 30.0444, longitude: 31.2357),
      Location(name: 'Moscow', country: 'RU', latitude: 55.7558, longitude: 37.6176),
      Location(name: 'Rome', country: 'IT', latitude: 41.9028, longitude: 12.4964),
      Location(name: 'Madrid', country: 'ES', latitude: 40.4168, longitude: -3.7038),
      Location(name: 'Bangkok', country: 'TH', latitude: 13.7563, longitude: 100.5018),
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

  /// Dispose method for compatibility
  void dispose() {
    // Nothing to dispose for dummy service
  }
}