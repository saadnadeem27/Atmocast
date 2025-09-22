import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/forecast.dart';
import '../../providers/app_settings_provider.dart';

class HourlyForecastList extends StatelessWidget {
  final List<HourlyForecast> hourlyForecast;

  const HourlyForecastList({
    super.key,
    required this.hourlyForecast,
  });

  @override
  Widget build(BuildContext context) {
    if (hourlyForecast.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.cardBorder,
            width: 1,
          ),
        ),
        child: const Center(
          child: Text(
            'No hourly forecast available',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyForecast.length,
        itemBuilder: (context, index) {
          final forecast = hourlyForecast[index];
          return _HourlyForecastItem(
            forecast: forecast,
            isFirst: index == 0,
          );
        },
      ),
    );
  }
}

class _HourlyForecastItem extends StatelessWidget {
  final HourlyForecast forecast;
  final bool isFirst;

  const _HourlyForecastItem({
    required this.forecast,
    this.isFirst = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          width: 80,
          margin: EdgeInsets.only(
            right: 12,
            left: isFirst ? 0 : 0,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.glassEffect,
                AppColors.cardBackground,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isFirst
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.cardBorder,
              width: isFirst ? 2 : 1,
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Time
              Text(
                _getTimeString(forecast.dateTime, isFirst),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color:
                          isFirst ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isFirst ? FontWeight.w600 : FontWeight.normal,
                    ),
                textAlign: TextAlign.center,
              ),

              // Weather Icon
              Text(
                forecast.weatherEmoji,
                style: const TextStyle(fontSize: 28),
              ),

              // Temperature
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  forecast.temperature.getTemperatureString(
                    settings.temperatureUnit,
                  ),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color:
                            isFirst ? AppColors.primary : AppColors.textPrimary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Precipitation probability
              if (forecast.precipitationProbability != null &&
                  forecast.precipitationProbability! > 0.1)
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 12,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          '${(forecast.precipitationProbability! * 100).round()}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.info,
                                fontSize: 10,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _getTimeString(DateTime dateTime, bool isFirst) {
    if (isFirst) {
      return 'Now';
    }

    final now = DateTime.now();
    if (dateTime.day == now.day) {
      return DateFormat('HH:mm').format(dateTime);
    } else {
      return DateFormat('E HH:mm').format(dateTime);
    }
  }
}
