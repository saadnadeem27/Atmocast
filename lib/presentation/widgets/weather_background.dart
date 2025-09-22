import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../providers/weather_provider.dart';

class WeatherBackground extends StatefulWidget {
  const WeatherBackground({super.key});

  @override
  State<WeatherBackground> createState() => _WeatherBackgroundState();
}

class _WeatherBackgroundState extends State<WeatherBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.linear),
    );
    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherProvider>(
      builder: (context, weatherProvider, child) {
        final weatherData = weatherProvider.currentWeather;
        final colors = _getGradientColors(
            weatherData?.primaryCondition.main, weatherData?.isDay);

        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: colors,
                  stops: _getGradientStops(colors.length),
                ),
              ),
              child: Stack(
                children: [
                  // Floating particles/stars effect
                  if (weatherData?.isDay == false) _buildStarsEffect(),

                  // Cloud effects for cloudy weather
                  if (weatherData?.primaryCondition.main.toLowerCase() ==
                      'clouds')
                    _buildCloudEffect(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<double> _getGradientStops(int colorCount) {
    // Ensure we always have valid stops
    switch (colorCount) {
      case 1:
        return [0.0];
      case 2:
        return [0.0, 1.0];
      case 3:
        return [
          0.0,
          0.5 + (_animation.value * 0.1).clamp(0.0, 0.4),
          1.0,
        ];
      case 4:
        return [
          0.0,
          0.3 + (_animation.value * 0.1).clamp(0.0, 0.2),
          0.7 + (_animation.value * 0.1).clamp(0.0, 0.2),
          1.0,
        ];
      default:
        // Fallback for any other case
        return List.generate(colorCount, (index) => index / (colorCount - 1));
    }
  }

  List<Color> _getGradientColors(String? condition, bool? isDay) {
    // Always return exactly 3 colors for consistency
    if (condition == null || isDay == null) {
      return AppColors.nightGradient;
    }

    if (!isDay) {
      return AppColors.nightGradient;
    }

    switch (condition.toLowerCase()) {
      case 'clear':
        return AppColors.sunnyGradient;
      case 'clouds':
        return AppColors.cloudyGradient;
      case 'rain':
      case 'drizzle':
        return AppColors.rainyGradient;
      case 'thunderstorm':
        return AppColors.rainyGradient; // Use consistent 3-color gradient
      case 'snow':
        return AppColors.snowGradient;
      case 'mist':
      case 'fog':
        return AppColors.cloudyGradient; // Use consistent 3-color gradient
      default:
        return AppColors.cloudyGradient;
    }
  }

  Widget _buildStarsEffect() {
    return Stack(
      children: List.generate(50, (index) {
        final double left = (index * 47.3) % MediaQuery.of(context).size.width;
        final double top = (index * 23.7) % MediaQuery.of(context).size.height;
        final double opacity = (0.3 + (index % 3) * 0.2) *
            (0.5 + 0.5 * (_animation.value + index * 0.1) % 1.0);

        return Positioned(
          left: left,
          top: top,
          child: Opacity(
            opacity: opacity.clamp(0.0, 0.8),
            child: Container(
              width: 2,
              height: 2,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildCloudEffect() {
    return Stack(
      children: [
        Positioned(
          top: 100 + (_animation.value * 20),
          right: -50 + (_animation.value * 30),
          child: Opacity(
            opacity: 0.1,
            child: Container(
              width: 200,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
          ),
        ),
        Positioned(
          top: 200 - (_animation.value * 15),
          left: -30 - (_animation.value * 20),
          child: Opacity(
            opacity: 0.08,
            child: Container(
              width: 150,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
