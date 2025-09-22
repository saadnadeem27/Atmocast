class Wind {
  final double speed;
  final int direction;
  final double? gust;

  const Wind({
    required this.speed,
    required this.direction,
    this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) {
    return Wind(
      speed: (json['speed'] ?? 0).toDouble(),
      direction: (json['deg'] ?? 0).toInt(),
      gust: json['gust']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speed': speed,
      'deg': direction,
      if (gust != null) 'gust': gust,
    };
  }

  double getSpeedInUnit(String unit) {
    switch (unit.toLowerCase()) {
      case 'mph':
        return speed * 2.237; // m/s to mph
      case 'kmh':
      case 'km/h':
        return speed * 3.6; // m/s to km/h
      case 'ms':
      case 'm/s':
      default:
        return speed;
    }
  }

  String getSpeedString(String unit, {bool includeUnit = true}) {
    final windSpeed = getSpeedInUnit(unit);
    final unitSymbol = _getUnitSymbol(unit);
    return '${windSpeed.toStringAsFixed(1)}${includeUnit ? ' $unitSymbol' : ''}';
  }

  String _getUnitSymbol(String unit) {
    switch (unit.toLowerCase()) {
      case 'mph':
        return 'mph';
      case 'kmh':
      case 'km/h':
        return 'km/h';
      case 'ms':
      case 'm/s':
      default:
        return 'm/s';
    }
  }

  String getDirectionString() {
    const directions = [
      'N',
      'NNE',
      'NE',
      'ENE',
      'E',
      'ESE',
      'SE',
      'SSE',
      'S',
      'SSW',
      'SW',
      'WSW',
      'W',
      'WNW',
      'NW',
      'NNW'
    ];

    final index = ((direction + 11.25) / 22.5).floor() % 16;
    return directions[index];
  }

  String getDirectionDescription() {
    switch (getDirectionString()) {
      case 'N':
        return 'North';
      case 'NNE':
        return 'North-Northeast';
      case 'NE':
        return 'Northeast';
      case 'ENE':
        return 'East-Northeast';
      case 'E':
        return 'East';
      case 'ESE':
        return 'East-Southeast';
      case 'SE':
        return 'Southeast';
      case 'SSE':
        return 'South-Southeast';
      case 'S':
        return 'South';
      case 'SSW':
        return 'South-Southwest';
      case 'SW':
        return 'Southwest';
      case 'WSW':
        return 'West-Southwest';
      case 'W':
        return 'West';
      case 'WNW':
        return 'West-Northwest';
      case 'NW':
        return 'Northwest';
      case 'NNW':
        return 'North-Northwest';
      default:
        return 'Unknown';
    }
  }

  String getBeaufortScale() {
    final speedMs = speed;
    if (speedMs < 0.3) return 'Calm';
    if (speedMs < 1.6) return 'Light air';
    if (speedMs < 3.4) return 'Light breeze';
    if (speedMs < 5.5) return 'Gentle breeze';
    if (speedMs < 8.0) return 'Moderate breeze';
    if (speedMs < 10.8) return 'Fresh breeze';
    if (speedMs < 13.9) return 'Strong breeze';
    if (speedMs < 17.2) return 'Near gale';
    if (speedMs < 20.8) return 'Gale';
    if (speedMs < 24.5) return 'Strong gale';
    if (speedMs < 28.5) return 'Storm';
    if (speedMs < 32.7) return 'Violent storm';
    return 'Hurricane';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Wind &&
        other.speed == speed &&
        other.direction == direction &&
        other.gust == gust;
  }

  @override
  int get hashCode {
    return speed.hashCode ^ direction.hashCode ^ gust.hashCode;
  }

  @override
  String toString() {
    return 'Wind(speed: $speed, direction: $direction, gust: $gust)';
  }
}
