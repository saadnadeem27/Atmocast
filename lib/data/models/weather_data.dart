import 'weather_condition.dart';
import 'temperature.dart';
import 'wind.dart';
import 'location.dart';

class WeatherData {
  final Location location;
  final DateTime dateTime;
  final Temperature temperature;
  final List<WeatherCondition> conditions;
  final Wind wind;
  final double humidity;
  final double pressure;
  final double visibility;
  final double? uvIndex;
  final int cloudCover;
  final double? dewPoint;
  final DateTime sunrise;
  final DateTime sunset;
  final DateTime? lastUpdated;

  const WeatherData({
    required this.location,
    required this.dateTime,
    required this.temperature,
    required this.conditions,
    required this.wind,
    required this.humidity,
    required this.pressure,
    required this.visibility,
    this.uvIndex,
    required this.cloudCover,
    this.dewPoint,
    required this.sunrise,
    required this.sunset,
    this.lastUpdated,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, Location location) {
    final main = json['main'] ?? {};
    final wind = json['wind'] ?? {};
    final sys = json['sys'] ?? {};
    final weather = json['weather'] as List? ?? [];

    return WeatherData(
      location: location,
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temperature: Temperature.fromJson(main),
      conditions: weather.map((w) => WeatherCondition.fromJson(w)).toList(),
      wind: Wind.fromJson(wind),
      humidity: (main['humidity'] ?? 0).toDouble(),
      pressure: (main['pressure'] ?? 0).toDouble(),
      visibility: (json['visibility'] ?? 0).toDouble(),
      uvIndex: json['uvi']?.toDouble(),
      cloudCover: (json['clouds']?['all'] ?? 0).toInt(),
      dewPoint: json['dew_point']?.toDouble(),
      sunrise:
          DateTime.fromMillisecondsSinceEpoch((sys['sunrise'] ?? 0) * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch((sys['sunset'] ?? 0) * 1000),
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location.toJson(),
      'dt': dateTime.millisecondsSinceEpoch ~/ 1000,
      'main': {
        'temp': temperature.current,
        'feels_like': temperature.feelsLike,
        'temp_min': temperature.min,
        'temp_max': temperature.max,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': conditions.map((c) => c.toJson()).toList(),
      'wind': wind.toJson(),
      'visibility': visibility,
      if (uvIndex != null) 'uvi': uvIndex,
      'clouds': {'all': cloudCover},
      if (dewPoint != null) 'dew_point': dewPoint,
      'sys': {
        'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000,
        'sunset': sunset.millisecondsSinceEpoch ~/ 1000,
      },
      if (lastUpdated != null)
        'last_updated': lastUpdated!.millisecondsSinceEpoch,
    };
  }

  WeatherCondition get primaryCondition {
    return conditions.isNotEmpty
        ? conditions.first
        : const WeatherCondition(
            id: 0, main: 'Unknown', description: 'Unknown', icon: '01d');
  }

  bool get isDay {
    final now = DateTime.now();
    return now.isAfter(sunrise) && now.isBefore(sunset);
  }

  String get weatherIcon {
    return primaryCondition.icon;
  }

  String get weatherEmoji {
    switch (primaryCondition.main.toLowerCase()) {
      case 'clear':
        return isDay ? '☀️' : '🌙';
      case 'clouds':
        return cloudCover > 75 ? '☁️' : '⛅';
      case 'rain':
        return '🌧️';
      case 'drizzle':
        return '🌦️';
      case 'thunderstorm':
        return '⛈️';
      case 'snow':
        return '❄️';
      case 'mist':
      case 'fog':
        return '🌫️';
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'sand':
      case 'ash':
        return '😶‍🌫️';
      case 'squall':
      case 'tornado':
        return '🌪️';
      default:
        return '🌤️';
    }
  }

  String getHumidityString() {
    return '${humidity.round()}%';
  }

  String getPressureString(String unit) {
    switch (unit.toLowerCase()) {
      case 'inhg':
        return '${(pressure * 0.02953).toStringAsFixed(2)} inHg';
      case 'hpa':
      default:
        return '${pressure.round()} hPa';
    }
  }

  String getVisibilityString(String unit) {
    switch (unit.toLowerCase()) {
      case 'miles':
        return '${(visibility / 1000 * 0.6214).toStringAsFixed(1)} mi';
      case 'km':
      default:
        return '${(visibility / 1000).toStringAsFixed(1)} km';
    }
  }

  String getUvIndexString() {
    if (uvIndex == null) return 'N/A';
    final uv = uvIndex!.round();
    if (uv <= 2) return '$uv (Low)';
    if (uv <= 5) return '$uv (Moderate)';
    if (uv <= 7) return '$uv (High)';
    if (uv <= 10) return '$uv (Very High)';
    return '$uv (Extreme)';
  }

  String getCloudCoverString() {
    return '$cloudCover%';
  }

  String getDewPointString(String unit) {
    if (dewPoint == null) return 'N/A';
    final temp = Temperature(
      current: dewPoint!,
      feelsLike: dewPoint!,
      min: dewPoint!,
      max: dewPoint!,
    );
    return temp.getTemperatureString(unit);
  }

  bool get isDataFresh {
    if (lastUpdated == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastUpdated!);
    return difference.inMinutes < 30; // Consider data fresh for 30 minutes
  }

  WeatherData copyWith({
    Location? location,
    DateTime? dateTime,
    Temperature? temperature,
    List<WeatherCondition>? conditions,
    Wind? wind,
    double? humidity,
    double? pressure,
    double? visibility,
    double? uvIndex,
    int? cloudCover,
    double? dewPoint,
    DateTime? sunrise,
    DateTime? sunset,
    DateTime? lastUpdated,
  }) {
    return WeatherData(
      location: location ?? this.location,
      dateTime: dateTime ?? this.dateTime,
      temperature: temperature ?? this.temperature,
      conditions: conditions ?? this.conditions,
      wind: wind ?? this.wind,
      humidity: humidity ?? this.humidity,
      pressure: pressure ?? this.pressure,
      visibility: visibility ?? this.visibility,
      uvIndex: uvIndex ?? this.uvIndex,
      cloudCover: cloudCover ?? this.cloudCover,
      dewPoint: dewPoint ?? this.dewPoint,
      sunrise: sunrise ?? this.sunrise,
      sunset: sunset ?? this.sunset,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeatherData &&
        other.location == location &&
        other.dateTime == dateTime &&
        other.temperature == temperature &&
        other.conditions == conditions &&
        other.wind == wind &&
        other.humidity == humidity &&
        other.pressure == pressure &&
        other.visibility == visibility &&
        other.uvIndex == uvIndex &&
        other.cloudCover == cloudCover &&
        other.dewPoint == dewPoint &&
        other.sunrise == sunrise &&
        other.sunset == sunset;
  }

  @override
  int get hashCode {
    return location.hashCode ^
        dateTime.hashCode ^
        temperature.hashCode ^
        conditions.hashCode ^
        wind.hashCode ^
        humidity.hashCode ^
        pressure.hashCode ^
        visibility.hashCode ^
        uvIndex.hashCode ^
        cloudCover.hashCode ^
        dewPoint.hashCode ^
        sunrise.hashCode ^
        sunset.hashCode;
  }

  @override
  String toString() {
    return 'WeatherData(location: ${location.name}, '
        'temperature: ${temperature.current}°C, '
        'condition: ${primaryCondition.main}, '
        'dateTime: $dateTime)';
  }
}
