class Temperature {
  final double current;
  final double feelsLike;
  final double min;
  final double max;
  final double? morning;
  final double? day;
  final double? evening;
  final double? night;

  const Temperature({
    required this.current,
    required this.feelsLike,
    required this.min,
    required this.max,
    this.morning,
    this.day,
    this.evening,
    this.night,
  });

  factory Temperature.fromJson(Map<String, dynamic> json) {
    return Temperature(
      current: (json['temp'] ?? json['main']?['temp'] ?? 0).toDouble(),
      feelsLike:
          (json['feels_like'] ?? json['main']?['feels_like'] ?? 0).toDouble(),
      min: (json['temp_min'] ?? json['main']?['temp_min'] ?? 0).toDouble(),
      max: (json['temp_max'] ?? json['main']?['temp_max'] ?? 0).toDouble(),
      morning: json['morn']?.toDouble(),
      day: json['day']?.toDouble(),
      evening: json['eve']?.toDouble(),
      night: json['night']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temp': current,
      'feels_like': feelsLike,
      'temp_min': min,
      'temp_max': max,
      if (morning != null) 'morn': morning,
      if (day != null) 'day': day,
      if (evening != null) 'eve': evening,
      if (night != null) 'night': night,
    };
  }

  double getTemperatureInUnit(String unit) {
    switch (unit.toLowerCase()) {
      case 'fahrenheit':
      case 'imperial':
        return (current * 9 / 5) + 32;
      case 'kelvin':
        return current + 273.15;
      case 'celsius':
      case 'metric':
      default:
        return current;
    }
  }

  String getTemperatureString(String unit, {bool includeUnit = true}) {
    final temp = getTemperatureInUnit(unit);
    final unitSymbol = _getUnitSymbol(unit);
    return '${temp.round()}${includeUnit ? unitSymbol : ''}';
  }

  String _getUnitSymbol(String unit) {
    switch (unit.toLowerCase()) {
      case 'fahrenheit':
      case 'imperial':
        return '°F';
      case 'kelvin':
        return 'K';
      case 'celsius':
      case 'metric':
      default:
        return '°C';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Temperature &&
        other.current == current &&
        other.feelsLike == feelsLike &&
        other.min == min &&
        other.max == max &&
        other.morning == morning &&
        other.day == day &&
        other.evening == evening &&
        other.night == night;
  }

  @override
  int get hashCode {
    return current.hashCode ^
        feelsLike.hashCode ^
        min.hashCode ^
        max.hashCode ^
        morning.hashCode ^
        day.hashCode ^
        evening.hashCode ^
        night.hashCode;
  }

  @override
  String toString() {
    return 'Temperature(current: $current, feelsLike: $feelsLike, min: $min, max: $max)';
  }
}
