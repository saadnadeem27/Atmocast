import 'package:flutter/material.dart';
import 'dart:math' as math;

import '../../core/constants/app_colors.dart';
import '../widgets/weather_background.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;
  late Animation<double> _chartAnimation;

  String selectedPeriod = '7D';
  final List<String> periods = ['24H', '7D', '30D', '1Y'];

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _chartAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _chartAnimationController, curve: Curves.easeInOut),
    );
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          const WeatherBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodSelector(),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildTemperatureChart(),
                  const SizedBox(height: 24),
                  _buildWeatherDistribution(),
                  const SizedBox(height: 24),
                  _buildHourlyPattern(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Weather Analytics',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () => _exportData(),
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareAnalytics(),
        ),
      ],
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: periods.map((period) {
          final isSelected = period == selectedPeriod;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => selectedPeriod = period),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  period,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        _buildStatCard(
          'Avg Temperature',
          '22°C',
          Icons.thermostat,
          AppColors.warning,
          '+2.5°',
        ),
        _buildStatCard(
          'Humidity',
          '65%',
          Icons.water_drop,
          AppColors.info,
          '-5%',
        ),
        _buildStatCard(
          'Wind Speed',
          '12 km/h',
          Icons.air,
          AppColors.success,
          '+1.2 km/h',
        ),
        _buildStatCard(
          'Pressure',
          '1013 hPa',
          Icons.speed,
          AppColors.primary,
          '+2 hPa',
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String change) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Text(
                change,
                style: TextStyle(
                  color: change.startsWith('+')
                      ? AppColors.success
                      : AppColors.error,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemperatureChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.glassEffect,
            AppColors.cardBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Temperature Trend',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '°C',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: AnimatedBuilder(
              animation: _chartAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: TemperatureChartPainter(_chartAnimation.value),
                  size: const Size(double.infinity, 200),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherDistribution() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.glassEffect,
            AppColors.cardBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weather Distribution',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 150,
                  child: AnimatedBuilder(
                    animation: _chartAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: PieChartPainter(_chartAnimation.value),
                        size: const Size(150, 150),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    _buildLegendItem('Sunny', AppColors.warning, 45),
                    _buildLegendItem('Cloudy', AppColors.info, 30),
                    _buildLegendItem('Rainy', AppColors.primary, 20),
                    _buildLegendItem('Other', AppColors.textSecondary, 5),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '$percentage%',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHourlyPattern() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.glassEffect,
            AppColors.cardBackground,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hourly Pattern',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 100,
            child: AnimatedBuilder(
              animation: _chartAnimation,
              builder: (context, child) {
                return CustomPaint(
                  painter: HourlyPatternPainter(_chartAnimation.value),
                  size: const Size(double.infinity, 100),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    // Implementation for data export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analytics data exported successfully')),
    );
  }

  void _shareAnalytics() {
    // Implementation for sharing analytics
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Analytics shared successfully')),
    );
  }
}

class TemperatureChartPainter extends CustomPainter {
  final double animationValue;

  TemperatureChartPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withOpacity(0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    final points = _generateTemperatureData();

    if (points.isNotEmpty) {
      final animatedPoints =
          points.take((points.length * animationValue).round()).toList();

      if (animatedPoints.isNotEmpty) {
        path.moveTo(animatedPoints.first.dx, animatedPoints.first.dy);
        fillPath.moveTo(animatedPoints.first.dx, size.height);
        fillPath.lineTo(animatedPoints.first.dx, animatedPoints.first.dy);

        for (int i = 1; i < animatedPoints.length; i++) {
          path.lineTo(animatedPoints[i].dx, animatedPoints[i].dy);
          fillPath.lineTo(animatedPoints[i].dx, animatedPoints[i].dy);
        }

        fillPath.lineTo(animatedPoints.last.dx, size.height);
        fillPath.close();

        canvas.drawPath(fillPath, fillPaint);
        canvas.drawPath(path, paint);

        // Draw points
        for (final point in animatedPoints) {
          canvas.drawCircle(point, 4, Paint()..color = AppColors.primary);
        }
      }
    }
  }

  List<Offset> _generateTemperatureData() {
    final points = <Offset>[];
    const dataPoints = 7;

    for (int i = 0; i < dataPoints; i++) {
      final x = (i / (dataPoints - 1)) * 300;
      final temp = 20 + math.sin(i * 0.5) * 10; // Simulated temperature data
      final y = 150 - (temp / 40) * 150; // Scale to chart height
      points.add(Offset(x, y));
    }

    return points;
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PieChartPainter extends CustomPainter {
  final double animationValue;

  PieChartPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 10;

    final data = [45, 30, 20, 5]; // Percentages
    final colors = [
      AppColors.warning,
      AppColors.info,
      AppColors.primary,
      AppColors.textSecondary
    ];

    double startAngle = -math.pi / 2;

    for (int i = 0; i < data.length; i++) {
      final sweepAngle = (data[i] / 100) * 2 * math.pi * animationValue;
      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class HourlyPatternPainter extends CustomPainter {
  final double animationValue;

  HourlyPatternPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.fill;

    const barCount = 24;
    final barWidth = size.width / barCount;

    for (int i = 0; i < barCount; i++) {
      if (i / barCount <= animationValue) {
        final height = (math.sin(i * 0.3) * 0.5 + 0.5) * size.height * 0.8;
        final x = i * barWidth;
        final y = size.height - height;

        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x + 2, y, barWidth - 4, height),
            const Radius.circular(2),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
