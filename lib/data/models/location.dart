class Location {
  final String name;
  final String country;
  final String? state;
  final double latitude;
  final double longitude;
  final String? timezone;
  final bool isCurrentLocation;

  const Location({
    required this.name,
    required this.country,
    this.state,
    required this.latitude,
    required this.longitude,
    this.timezone,
    this.isCurrentLocation = false,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'] ?? json['local_names']?['en'] ?? 'Unknown',
      country: json['country'] ?? '',
      state: json['state'],
      latitude: (json['lat'] ?? 0).toDouble(),
      longitude: (json['lon'] ?? 0).toDouble(),
      timezone: json['timezone'],
      isCurrentLocation: json['isCurrentLocation'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'country': country,
      if (state != null) 'state': state,
      'lat': latitude,
      'lon': longitude,
      if (timezone != null) 'timezone': timezone,
      'isCurrentLocation': isCurrentLocation,
    };
  }

  String get displayName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state, $country';
    }
    return '$name, $country';
  }

  String get shortDisplayName {
    if (state != null && state!.isNotEmpty) {
      return '$name, $state';
    }
    return name;
  }

  String get coordinates {
    return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  }

  Location copyWith({
    String? name,
    String? country,
    String? state,
    double? latitude,
    double? longitude,
    String? timezone,
    bool? isCurrentLocation,
  }) {
    return Location(
      name: name ?? this.name,
      country: country ?? this.country,
      state: state ?? this.state,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      isCurrentLocation: isCurrentLocation ?? this.isCurrentLocation,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Location &&
        other.name == name &&
        other.country == country &&
        other.state == state &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.timezone == timezone &&
        other.isCurrentLocation == isCurrentLocation;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        country.hashCode ^
        state.hashCode ^
        latitude.hashCode ^
        longitude.hashCode ^
        timezone.hashCode ^
        isCurrentLocation.hashCode;
  }

  @override
  String toString() {
    return 'Location(name: $name, country: $country, state: $state, '
        'latitude: $latitude, longitude: $longitude, '
        'timezone: $timezone, isCurrentLocation: $isCurrentLocation)';
  }
}
