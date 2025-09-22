import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/forecast.dart';
import '../../providers/app_settings_provider.dart';

class DailyForecastList extends StatelessWidget {
  final List<DailyForecast> dailyForecast;

  const DailyForecastList({
    super.key,
    required this.dailyForecast,
  });

  @override
  Widget build(BuildContext context) {
    if (dailyForecast.isEmpty) {
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
            'No daily forecast available',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
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
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        children: dailyForecast.asMap().entries.map((entry) {
          final index = entry.key;
          final forecast = entry.value;
          return _DailyForecastItem(
            forecast: forecast,
            isToday: index == 0,
            isLast: index == dailyForecast.length - 1,
          );
        }).toList(),
      ),
    );
  }
}

class _DailyForecastItem extends StatelessWidget {
  final DailyForecast forecast;
  final bool isToday;
  final bool isLast;

  const _DailyForecastItem({
    required this.forecast,
    this.isToday = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settings, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: isLast
                ? null
                : const Border(
                    bottom: BorderSide(
                      color: AppColors.cardBorder,
                      width: 0.5,
                    ),
                  ),
          ),
          child: Row(
            children: [
              // Day of week
              Expanded(
                flex: 2,
                child: Text(
                  _getDayString(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isToday ? FontWeight.w600 : FontWeight.w500,
                        color:
                            isToday ? AppColors.primary : AppColors.textPrimary,
                      ),
                ),
              ),

              // Weather icon and condition
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Text(
                      forecast.weatherEmoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        forecast.primaryCondition.main,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Precipitation probability
              if (forecast.precipitationProbability != null &&
                  forecast.precipitationProbability! > 0.1)
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.water_drop,
                        size: 14,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${(forecast.precipitationProbability! * 100).round()}%',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.info,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                )
              else
                const Expanded(flex: 1, child: SizedBox()),

              // Temperature range
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Min temperature
                    Flexible(
                      child: Text(
                        '${forecast.temperature.min.round()}°',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w400,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Temperature bar (visual representation)
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.info.withOpacity(0.3),
                            AppColors.warning,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Max temperature
                    Flexible(
                      child: Text(
                        '${forecast.temperature.max.round()}°',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
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

  String _getDayString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final forecastDate =
        DateTime(forecast.date.year, forecast.date.month, forecast.date.day);

    if (forecastDate == today) {
      return 'Today';
    } else if (forecastDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEEE').format(forecast.date);
    }
  }
}
