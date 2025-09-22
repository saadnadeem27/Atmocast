import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../data/models/location.dart';
import '../../core/constants/app_constants.dart';

class AppSettingsProvider extends ChangeNotifier {
  // Private settings
  String _temperatureUnit = AppConstants.defaultTemperatureUnit;
  String _windSpeedUnit = AppConstants.defaultWindSpeedUnit;
  String _pressureUnit = AppConstants.defaultPressureUnit;
  String _distanceUnit = AppConstants.defaultDistanceUnit;
  String _timeFormat = AppConstants.defaultTimeFormat;
  bool _darkMode = AppConstants.defaultDarkMode;
  bool _notifications = AppConstants.defaultNotifications;
  bool _autoLocation = AppConstants.defaultAutoLocation;
  String _language = AppConstants.defaultLanguage;

  List<Location> _savedLocations = [];
  Location? _currentLocation;

  bool _isInitialized = false;

  // Getters
  String get temperatureUnit => _temperatureUnit;
  String get windSpeedUnit => _windSpeedUnit;
  String get pressureUnit => _pressureUnit;
  String get distanceUnit => _distanceUnit;
  String get timeFormat => _timeFormat;
  bool get darkMode => _darkMode;
  bool get notifications => _notifications;
  bool get autoLocation => _autoLocation;
  String get language => _language;
  List<Location> get savedLocations => List.unmodifiable(_savedLocations);
  Location? get currentLocation => _currentLocation;
  bool get isInitialized => _isInitialized;

  /// Initialize settings from shared preferences
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      final prefs = await SharedPreferences.getInstance();

      _temperatureUnit = prefs.getString(AppConstants.keyTemperatureUnit) ??
          AppConstants.defaultTemperatureUnit;
      _windSpeedUnit = prefs.getString(AppConstants.keyWindSpeedUnit) ??
          AppConstants.defaultWindSpeedUnit;
      _pressureUnit = prefs.getString(AppConstants.keyPressureUnit) ??
          AppConstants.defaultPressureUnit;
      _distanceUnit = prefs.getString(AppConstants.keyDistanceUnit) ??
          AppConstants.defaultDistanceUnit;
      _timeFormat = prefs.getString(AppConstants.keyTimeFormat) ??
          AppConstants.defaultTimeFormat;
      _darkMode = prefs.getBool(AppConstants.keyDarkMode) ??
          AppConstants.defaultDarkMode;
      _notifications = prefs.getBool(AppConstants.keyNotifications) ??
          AppConstants.defaultNotifications;
      _autoLocation = prefs.getBool(AppConstants.keyAutoLocation) ??
          AppConstants.defaultAutoLocation;
      _language = prefs.getString(AppConstants.keyLanguage) ??
          AppConstants.defaultLanguage;

      // Load saved locations
      final savedLocationsJson =
          prefs.getString(AppConstants.keySelectedCities);
      if (savedLocationsJson != null) {
        final List<dynamic> locationsList = json.decode(savedLocationsJson);
        _savedLocations =
            locationsList.map((item) => Location.fromJson(item)).toList();
      }

      // Load current location
      final currentLocationJson =
          prefs.getString(AppConstants.keyCurrentLocation);
      if (currentLocationJson != null) {
        _currentLocation = Location.fromJson(json.decode(currentLocationJson));
      }

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Failed to initialize app settings: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Update temperature unit
  Future<void> setTemperatureUnit(String unit) async {
    if (_temperatureUnit == unit) return;

    _temperatureUnit = unit;
    notifyListeners();
    await _saveToPreferences(AppConstants.keyTemperatureUnit, unit);
  }

  /// Update wind speed unit
  Future<void> setWindSpeedUnit(String unit) async {
    if (_windSpeedUnit == unit) return;

    _windSpeedUnit = unit;
    notifyListeners();
    await _saveToPreferences(AppConstants.keyWindSpeedUnit, unit);
  }

  /// Update pressure unit
  Future<void> setPressureUnit(String unit) async {
    if (_pressureUnit == unit) return;

    _pressureUnit = unit;
    notifyListeners();
    await _saveToPreferences(AppConstants.keyPressureUnit, unit);
  }

  /// Update distance unit
  Future<void> setDistanceUnit(String unit) async {
    if (_distanceUnit == unit) return;

    _distanceUnit = unit;
    notifyListeners();
    await _saveToPreferences(AppConstants.keyDistanceUnit, unit);
  }

  /// Update time format
  Future<void> setTimeFormat(String format) async {
    if (_timeFormat == format) return;

    _timeFormat = format;
    notifyListeners();
    await _saveToPreferences(AppConstants.keyTimeFormat, format);
  }

  /// Toggle dark mode
  Future<void> setDarkMode(bool enabled) async {
    if (_darkMode == enabled) return;

    _darkMode = enabled;
    notifyListeners();
    await _saveBoolToPreferences(AppConstants.keyDarkMode, enabled);
  }

  /// Toggle notifications
  Future<void> setNotifications(bool enabled) async {
    if (_notifications == enabled) return;

    _notifications = enabled;
    notifyListeners();
    await _saveBoolToPreferences(AppConstants.keyNotifications, enabled);
  }

  /// Toggle auto location
  Future<void> setAutoLocation(bool enabled) async {
    if (_autoLocation == enabled) return;

    _autoLocation = enabled;
    notifyListeners();
    await _saveBoolToPreferences(AppConstants.keyAutoLocation, enabled);
  }

  /// Update language
  Future<void> setLanguage(String language) async {
    if (_language == language) return;

    _language = language;
    notifyListeners();
    await _saveToPreferences(AppConstants.keyLanguage, language);
  }

  /// Add a location to saved locations
  Future<void> addLocation(Location location) async {
    // Check if location already exists
    final exists = _savedLocations.any((loc) =>
        loc.latitude == location.latitude &&
        loc.longitude == location.longitude);

    if (!exists) {
      _savedLocations.add(location);
      notifyListeners();
      await _saveLocationsToPreferences();
    }
  }

  /// Remove a location from saved locations
  Future<void> removeLocation(Location location) async {
    _savedLocations.removeWhere((loc) =>
        loc.latitude == location.latitude &&
        loc.longitude == location.longitude);
    notifyListeners();
    await _saveLocationsToPreferences();
  }

  /// Update current location
  Future<void> setCurrentLocation(Location? location) async {
    _currentLocation = location;
    notifyListeners();

    if (location != null) {
      await _saveLocationToPreferences(
          AppConstants.keyCurrentLocation, location);
    } else {
      await _removeFromPreferences(AppConstants.keyCurrentLocation);
    }
  }

  /// Check if location is saved
  bool isLocationSaved(Location location) {
    return _savedLocations.any((loc) =>
        loc.latitude == location.latitude &&
        loc.longitude == location.longitude);
  }

  /// Get all locations (current + saved)
  List<Location> getAllLocations() {
    final allLocations = <Location>[];
    if (_currentLocation != null) {
      allLocations.add(_currentLocation!);
    }
    allLocations.addAll(_savedLocations);
    return allLocations;
  }

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    _temperatureUnit = AppConstants.defaultTemperatureUnit;
    _windSpeedUnit = AppConstants.defaultWindSpeedUnit;
    _pressureUnit = AppConstants.defaultPressureUnit;
    _distanceUnit = AppConstants.defaultDistanceUnit;
    _timeFormat = AppConstants.defaultTimeFormat;
    _darkMode = AppConstants.defaultDarkMode;
    _notifications = AppConstants.defaultNotifications;
    _autoLocation = AppConstants.defaultAutoLocation;
    _language = AppConstants.defaultLanguage;
    _savedLocations.clear();
    _currentLocation = null;

    notifyListeners();

    // Clear all settings from preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // Private helper methods
  Future<void> _saveToPreferences(String key, String value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } catch (e) {
      debugPrint('Failed to save setting $key: $e');
    }
  }

  Future<void> _saveBoolToPreferences(String key, bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(key, value);
    } catch (e) {
      debugPrint('Failed to save boolean setting $key: $e');
    }
  }

  Future<void> _saveLocationsToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationsJson = json.encode(
        _savedLocations.map((loc) => loc.toJson()).toList(),
      );
      await prefs.setString(AppConstants.keySelectedCities, locationsJson);
    } catch (e) {
      debugPrint('Failed to save locations: $e');
    }
  }

  Future<void> _saveLocationToPreferences(String key, Location location) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final locationJson = json.encode(location.toJson());
      await prefs.setString(key, locationJson);
    } catch (e) {
      debugPrint('Failed to save location $key: $e');
    }
  }

  Future<void> _removeFromPreferences(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } catch (e) {
      debugPrint('Failed to remove setting $key: $e');
    }
  }
}
