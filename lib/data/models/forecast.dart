import 'weather_condition.dart';
import 'temperature.dart';
import 'wind.dart';

class HourlyForecast {
  final DateTime dateTime;
  final Temperature temperature;
  final List<WeatherCondition> conditions;
  final Wind wind;
  final double humidity;
  final double pressure;
  final double? uvIndex;
  final int cloudCover;
  final double? precipitation;
  final double? precipitationProbability;

  const HourlyForecast({
    required this.dateTime,
    required this.temperature,
    required this.conditions,
    required this.wind,
    required this.humidity,
    required this.pressure,
    this.uvIndex,
    required this.cloudCover,
    this.precipitation,
    this.precipitationProbability,
  });

  factory HourlyForecast.fromJson(Map<String, dynamic> json) {
    final main = json['main'] ?? {};
    final wind = json['wind'] ?? {};
    final weather = json['weather'] as List? ?? [];

    return HourlyForecast(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temperature: Temperature.fromJson(main),
      conditions: weather.map((w) => WeatherCondition.fromJson(w)).toList(),
      wind: Wind.fromJson(wind),
      humidity: (main['humidity'] ?? 0).toDouble(),
      pressure: (main['pressure'] ?? 0).toDouble(),
      uvIndex: json['uvi']?.toDouble(),
      cloudCover: (json['clouds']?['all'] ?? 0).toInt(),
      precipitation:
          json['rain']?['1h']?.toDouble() ?? json['snow']?['1h']?.toDouble(),
      precipitationProbability: json['pop']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
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
      if (uvIndex != null) 'uvi': uvIndex,
      'clouds': {'all': cloudCover},
      if (precipitation != null) 'rain': {'1h': precipitation},
      if (precipitationProbability != null) 'pop': precipitationProbability,
    };
  }

  WeatherCondition get primaryCondition {
    return conditions.isNotEmpty
        ? conditions.first
        : const WeatherCondition(
            id: 0, main: 'Unknown', description: 'Unknown', icon: '01d');
  }

  String get weatherEmoji {
    switch (primaryCondition.main.toLowerCase()) {
      case 'clear':
        return dateTime.hour >= 6 && dateTime.hour < 18 ? '☀️' : '🌙';
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
      default:
        return '🌤️';
    }
  }

  String getPrecipitationString() {
    if (precipitation == null || precipitation == 0) return '0 mm';
    return '${precipitation!.toStringAsFixed(1)} mm';
  }

  String getPrecipitationProbabilityString() {
    if (precipitationProbability == null) return '0%';
    return '${(precipitationProbability! * 100).round()}%';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HourlyForecast &&
        other.dateTime == dateTime &&
        other.temperature == temperature &&
        other.conditions == conditions &&
        other.wind == wind &&
        other.humidity == humidity &&
        other.pressure == pressure &&
        other.uvIndex == uvIndex &&
        other.cloudCover == cloudCover &&
        other.precipitation == precipitation &&
        other.precipitationProbability == precipitationProbability;
  }

  @override
  int get hashCode {
    return dateTime.hashCode ^
        temperature.hashCode ^
        conditions.hashCode ^
        wind.hashCode ^
        humidity.hashCode ^
        pressure.hashCode ^
        uvIndex.hashCode ^
        cloudCover.hashCode ^
        precipitation.hashCode ^
        precipitationProbability.hashCode;
  }

  @override
  String toString() {
    return 'HourlyForecast(dateTime: $dateTime, '
        'temperature: ${temperature.current}°C, '
        'condition: ${primaryCondition.main})';
  }
}

class DailyForecast {
  final DateTime date;
  final Temperature temperature;
  final List<WeatherCondition> conditions;
  final Wind wind;
  final double humidity;
  final double pressure;
  final double? uvIndex;
  final int cloudCover;
  final double? precipitation;
  final double? precipitationProbability;
  final DateTime sunrise;
  final DateTime sunset;
  final String? summary;

  const DailyForecast({
    required this.date,
    required this.temperature,
    required this.conditions,
    required this.wind,
    required this.humidity,
    required this.pressure,
    this.uvIndex,
    required this.cloudCover,
    this.precipitation,
    this.precipitationProbability,
    required this.sunrise,
    required this.sunset,
    this.summary,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    final temp = json['temp'] ?? {};
    final weather = json['weather'] as List? ?? [];

    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch((json['dt'] ?? 0) * 1000),
      temperature: Temperature.fromJson(temp),
      conditions: weather.map((w) => WeatherCondition.fromJson(w)).toList(),
      wind: Wind.fromJson(json['wind'] ?? {}),
      humidity: (json['humidity'] ?? 0).toDouble(),
      pressure: (json['pressure'] ?? 0).toDouble(),
      uvIndex: json['uvi']?.toDouble(),
      cloudCover: (json['clouds'] ?? 0).toInt(),
      precipitation: json['rain']?.toDouble() ?? json['snow']?.toDouble(),
      precipitationProbability: json['pop']?.toDouble(),
      sunrise:
          DateTime.fromMillisecondsSinceEpoch((json['sunrise'] ?? 0) * 1000),
      sunset: DateTime.fromMillisecondsSinceEpoch((json['sunset'] ?? 0) * 1000),
      summary: json['summary'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dt': date.millisecondsSinceEpoch ~/ 1000,
      'temp': temperature.toJson(),
      'weather': conditions.map((c) => c.toJson()).toList(),
      'wind': wind.toJson(),
      'humidity': humidity,
      'pressure': pressure,
      if (uvIndex != null) 'uvi': uvIndex,
      'clouds': cloudCover,
      if (precipitation != null) 'rain': precipitation,
      if (precipitationProbability != null) 'pop': precipitationProbability,
      'sunrise': sunrise.millisecondsSinceEpoch ~/ 1000,
      'sunset': sunset.millisecondsSinceEpoch ~/ 1000,
      if (summary != null) 'summary': summary,
    };
  }

  WeatherCondition get primaryCondition {
    return conditions.isNotEmpty
        ? conditions.first
        : const WeatherCondition(
            id: 0, main: 'Unknown', description: 'Unknown', icon: '01d');
  }

  String get weatherEmoji {
    switch (primaryCondition.main.toLowerCase()) {
      case 'clear':
        return '☀️';
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
      default:
        return '🌤️';
    }
  }

  String getDayOfWeek() {
    const days = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];
    return days[date.weekday % 7];
  }

  String getShortDayOfWeek() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  String getPrecipitationString() {
    if (precipitation == null || precipitation == 0) return '0 mm';
    return '${precipitation!.toStringAsFixed(1)} mm';
  }

  String getPrecipitationProbabilityString() {
    if (precipitationProbability == null) return '0%';
    return '${(precipitationProbability! * 100).round()}%';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DailyForecast &&
        other.date == date &&
        other.temperature == temperature &&
        other.conditions == conditions &&
        other.wind == wind &&
        other.humidity == humidity &&
        other.pressure == pressure &&
        other.uvIndex == uvIndex &&
        other.cloudCover == cloudCover &&
        other.precipitation == precipitation &&
        other.precipitationProbability == precipitationProbability &&
        other.sunrise == sunrise &&
        other.sunset == sunset &&
        other.summary == summary;
  }

  @override
  int get hashCode {
    return date.hashCode ^
        temperature.hashCode ^
        conditions.hashCode ^
        wind.hashCode ^
        humidity.hashCode ^
        pressure.hashCode ^
        uvIndex.hashCode ^
        cloudCover.hashCode ^
        precipitation.hashCode ^
        precipitationProbability.hashCode ^
        sunrise.hashCode ^
        sunset.hashCode ^
        summary.hashCode;
  }

  @override
  String toString() {
    return 'DailyForecast(date: $date, '
        'temperature: ${temperature.current}°C, '
        'condition: ${primaryCondition.main})';
  }
}
