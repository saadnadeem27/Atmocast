import 'package:geolocator/geolocator.dart';

import '../models/location.dart';
import '../../core/constants/app_constants.dart';

class LocationServiceException implements Exception {
  final String message;

  const LocationServiceException(this.message);

  @override
  String toString() => 'LocationServiceException: $message';
}

class LocationService {
  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permission status
  Future<LocationPermission> checkLocationPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current location with comprehensive error handling
  Future<Location> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const LocationServiceException(AppConstants.errorLocation);
      }

      // Check and request permissions
      LocationPermission permission = await checkLocationPermission();

      if (permission == LocationPermission.denied) {
        permission = await requestLocationPermission();
        if (permission == LocationPermission.denied) {
          throw const LocationServiceException(AppConstants.errorPermission);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw const LocationServiceException(
          'Location permissions are permanently denied. Please enable them in settings.',
        );
      }

      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: AppConstants.locationTimeout,
      );

      return Location(
        name: 'Current Location',
        country: 'Unknown',
        latitude: position.latitude,
        longitude: position.longitude,
        isCurrentLocation: true,
      );
    } catch (e) {
      if (e is LocationServiceException) rethrow;
      throw LocationServiceException(
          'Failed to get current location: ${e.toString()}');
    }
  }

  /// Get last known location
  Future<Location?> getLastKnownLocation() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        return Location(
          name: 'Last Known Location',
          country: 'Unknown',
          latitude: position.latitude,
          longitude: position.longitude,
          isCurrentLocation: true,
        );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Calculate distance between two locations
  double calculateDistance(Location from, Location to) {
    return Geolocator.distanceBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Calculate bearing between two locations
  double calculateBearing(Location from, Location to) {
    return Geolocator.bearingBetween(
      from.latitude,
      from.longitude,
      to.latitude,
      to.longitude,
    );
  }

  /// Check if two locations are close to each other (within specified meters)
  bool areLocationsClose(Location location1, Location location2,
      {double threshold = 1000}) {
    final distance = calculateDistance(location1, location2);
    return distance <= threshold;
  }

  /// Open device location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Open app-specific location settings
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Get location permission status as a string
  String getPermissionStatusString(LocationPermission permission) {
    switch (permission) {
      case LocationPermission.denied:
        return 'Location permission denied';
      case LocationPermission.deniedForever:
        return 'Location permission permanently denied';
      case LocationPermission.whileInUse:
        return 'Location permission granted while in use';
      case LocationPermission.always:
        return 'Location permission always granted';
      case LocationPermission.unableToDetermine:
        return 'Unable to determine location permission';
    }
  }

  /// Check if location permission is granted
  Future<bool> isLocationPermissionGranted() async {
    final permission = await checkLocationPermission();
    return permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always;
  }

  /// Request location permission with user-friendly handling
  Future<bool> requestLocationPermissionWithRationale() async {
    try {
      // Check current permission status
      final currentPermission = await checkLocationPermission();

      if (currentPermission == LocationPermission.deniedForever) {
        // Permission is permanently denied, direct user to settings
        return false;
      }

      if (currentPermission == LocationPermission.denied) {
        // Request permission
        final permission = await requestLocationPermission();
        return permission == LocationPermission.whileInUse ||
            permission == LocationPermission.always;
      }

      // Permission already granted
      return currentPermission == LocationPermission.whileInUse ||
          currentPermission == LocationPermission.always;
    } catch (e) {
      return false;
    }
  }

  /// Get location with fallback options
  Future<Location> getLocationWithFallback() async {
    try {
      // Try to get current location
      return await getCurrentLocation();
    } catch (e) {
      try {
        // Fallback to last known location
        final lastKnown = await getLastKnownLocation();
        if (lastKnown != null) {
          return lastKnown;
        }
      } catch (e) {
        // Ignore last known location errors
      }

      // Final fallback to default location
      return const Location(
        name: 'Default Location',
        country: 'US',
        latitude: AppConstants.defaultLatitude,
        longitude: AppConstants.defaultLongitude,
        isCurrentLocation: false,
      );
    }
  }

  /// Listen to location changes (for real-time updates)
  Stream<Location> watchLocation({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
        timeLimit: AppConstants.locationTimeout,
      ),
    ).map((position) => Location(
          name: 'Current Location',
          country: 'Unknown',
          latitude: position.latitude,
          longitude: position.longitude,
          isCurrentLocation: true,
        ));
  }

  /// Format distance string
  String formatDistance(double distanceInMeters, String unit) {
    switch (unit.toLowerCase()) {
      case 'miles':
        final miles = distanceInMeters *
            AppConstants.distanceConversion['m_to_ft']! *
            AppConstants.distanceConversion['ft_to_m']! *
            AppConstants.distanceConversion['km_to_miles']! /
            1000;
        return '${miles.toStringAsFixed(1)} mi';
      case 'km':
      default:
        final km = distanceInMeters / 1000;
        return '${km.toStringAsFixed(1)} km';
    }
  }
}
