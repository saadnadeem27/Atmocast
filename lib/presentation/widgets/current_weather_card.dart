import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/weather_data.dart';
import '../../providers/app_settings_provider.dart';

class CurrentWeatherCard extends StatelessWidget {
  final WeatherData weatherData;
  final bool isLoading;

  const CurrentWeatherCard({
    super.key,
    required this.weatherData,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.glassEffect,
                AppColors.cardBackground,
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Location and Date
              _buildLocationAndDate(context),

              const SizedBox(height: 24),

              // Main Temperature and Condition
              _buildMainWeatherInfo(context, settings),

              const SizedBox(height: 24),

              // Temperature Range and Feels Like
              _buildTemperatureDetails(context, settings),

              const SizedBox(height: 16),

              // Last Updated
              if (weatherData.lastUpdated != null) _buildLastUpdated(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationAndDate(BuildContext context) {
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, MMMM d');
    final timeFormat = DateFormat('HH:mm');

    return Column(
      children: [
        Text(
          weatherData.location.name,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          '${dateFormat.format(now)} • ${timeFormat.format(now)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMainWeatherInfo(
      BuildContext context, AppSettingsProvider settings) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weather Icon/Emoji
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.glassEffect,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: Text(
            weatherData.weatherEmoji,
            style: const TextStyle(fontSize: 48),
          ),
        ),

        const SizedBox(width: 24),

        // Temperature and Condition
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weatherData.temperature.getTemperatureString(
                  settings.temperatureUnit,
                ),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 64,
                      fontWeight: FontWeight.w300,
                      height: 1.0,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                weatherData.primaryCondition.description.toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.2,
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureDetails(
      BuildContext context, AppSettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.glassEffect,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Feels Like
            Flexible(
              child: _buildDetailItem(
                context,
                AppStrings.feelsLike,
                weatherData.temperature.getTemperatureString(
                  settings.temperatureUnit,
                  includeUnit: false,
                ),
                _getTemperatureUnit(settings.temperatureUnit),
              ),
            ),

            // Divider
            Container(
              height: 40,
              width: 1,
              color: AppColors.cardBorder,
            ),

            // Min Temperature
            Flexible(
              child: _buildDetailItem(
                context,
                'Min',
                weatherData.temperature.min.round().toString(),
                _getTemperatureUnit(settings.temperatureUnit),
              ),
            ),

            // Divider
            Container(
              height: 40,
              width: 1,
              color: AppColors.cardBorder,
            ),

            // Max Temperature
            Flexible(
              child: _buildDetailItem(
                context,
                'Max',
                weatherData.temperature.max.round().toString(),
                _getTemperatureUnit(settings.temperatureUnit),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
      BuildContext context, String label, String value, String unit) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                unit,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLastUpdated(BuildContext context) {
    final lastUpdated = weatherData.lastUpdated!;
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);

    String timeAgo;
    if (difference.inMinutes < 1) {
      timeAgo = 'Just now';
    } else if (difference.inMinutes < 60) {
      timeAgo = '${difference.inMinutes}m ago';
    } else {
      timeAgo = '${difference.inHours}h ago';
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.access_time,
          size: 14,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: 4),
        Text(
          'Updated $timeAgo',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textTertiary,
              ),
        ),
      ],
    );
  }

  String _getTemperatureUnit(String unit) {
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
}
