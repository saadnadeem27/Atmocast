import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/weather_data.dart';
import '../../providers/app_settings_provider.dart';

class WeatherDetailsGrid extends StatelessWidget {
  final WeatherData weatherData;

  const WeatherDetailsGrid({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final crossAxisCount = screenWidth > 600 ? 3 : 2;
        final childAspectRatio = screenWidth > 600 ? 1.2 : 1.1;

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: childAspectRatio,
          children: [
            // Wind
            _WeatherDetailCard(
              title: AppStrings.windSpeed,
              value: weatherData.wind.getSpeedString(settings.windSpeedUnit),
              subtitle: weatherData.wind.getDirectionString(),
              icon: Icons.air,
              color: AppColors.info,
            ),

            // Humidity
            _WeatherDetailCard(
              title: AppStrings.humidity,
              value: weatherData.getHumidityString(),
              subtitle: _getHumidityDescription(weatherData.humidity),
              icon: Icons.water_drop,
              color: AppColors.info,
            ),

            // UV Index
            _WeatherDetailCard(
              title: AppStrings.uvIndex,
              value: weatherData.uvIndex?.round().toString() ?? 'N/A',
              subtitle: _getUvIndexDescription(weatherData.uvIndex),
              icon: Icons.wb_sunny,
              color: _getUvIndexColor(weatherData.uvIndex),
            ),

            // Pressure
            _WeatherDetailCard(
              title: AppStrings.pressure,
              value: weatherData.getPressureString(settings.pressureUnit),
              subtitle: _getPressureDescription(weatherData.pressure),
              icon: Icons.speed,
              color: AppColors.primary,
            ),

            // Visibility
            _WeatherDetailCard(
              title: AppStrings.visibility,
              value: weatherData.getVisibilityString(settings.distanceUnit),
              subtitle: _getVisibilityDescription(weatherData.visibility),
              icon: Icons.visibility,
              color: AppColors.success,
            ),

            // Cloud Cover
            _WeatherDetailCard(
              title: AppStrings.cloudCover,
              value: weatherData.getCloudCoverString(),
              subtitle: _getCloudCoverDescription(weatherData.cloudCover),
              icon: Icons.cloud,
              color: AppColors.textSecondary,
            ),
          ],
        );
      },
    );
  }

  String _getHumidityDescription(double humidity) {
    if (humidity < 30) return 'Dry';
    if (humidity < 60) return 'Comfortable';
    if (humidity < 80) return 'Humid';
    return 'Very Humid';
  }

  String _getUvIndexDescription(double? uvIndex) {
    if (uvIndex == null) return 'Unknown';
    if (uvIndex <= 2) return 'Low';
    if (uvIndex <= 5) return 'Moderate';
    if (uvIndex <= 7) return 'High';
    if (uvIndex <= 10) return 'Very High';
    return 'Extreme';
  }

  Color _getUvIndexColor(double? uvIndex) {
    if (uvIndex == null) return AppColors.textSecondary;
    if (uvIndex <= 2) return AppColors.success;
    if (uvIndex <= 5) return AppColors.warning;
    if (uvIndex <= 7) return AppColors.error;
    return AppColors.uvVeryHigh;
  }

  String _getPressureDescription(double pressure) {
    if (pressure < 1010) return 'Low';
    if (pressure < 1020) return 'Normal';
    return 'High';
  }

  String _getVisibilityDescription(double visibility) {
    if (visibility < 1000) return 'Poor';
    if (visibility < 5000) return 'Moderate';
    if (visibility < 10000) return 'Good';
    return 'Excellent';
  }

  String _getCloudCoverDescription(int cloudCover) {
    if (cloudCover < 25) return 'Clear';
    if (cloudCover < 50) return 'Partly Cloudy';
    if (cloudCover < 75) return 'Mostly Cloudy';
    return 'Overcast';
  }
}

class _WeatherDetailCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _WeatherDetailCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.all(MediaQuery.of(context).size.width > 600 ? 20 : 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.glassEffect,
            AppColors.cardBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon and Title
              Flexible(
                child: Row(
                  children: [
                    Container(
                      padding:
                          EdgeInsets.all(constraints.maxWidth > 140 ? 8 : 6),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        icon,
                        size: constraints.maxWidth > 140 ? 20 : 16,
                        color: color,
                      ),
                    ),
                    SizedBox(width: constraints.maxWidth > 140 ? 8 : 6),
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                              fontSize: constraints.maxWidth > 140 ? 13 : 11,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Value
              Flexible(
                flex: 2,
                child: SizedBox(
                  width: double.infinity,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            fontSize: constraints.maxWidth > 140 ? 22 : 18,
                          ),
                      maxLines: 1,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // Subtitle
              Flexible(
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: constraints.maxWidth > 140 ? 12 : 10,
                        ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
