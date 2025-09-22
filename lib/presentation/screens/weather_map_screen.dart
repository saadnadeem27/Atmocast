import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../widgets/weather_background.dart';

class WeatherMapScreen extends StatefulWidget {
  const WeatherMapScreen({super.key});

  @override
  State<WeatherMapScreen> createState() => _WeatherMapScreenState();
}

class _WeatherMapScreenState extends State<WeatherMapScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String selectedLayer = 'temperature';
  double mapZoom = 1.0;

  final List<Map<String, dynamic>> weatherLayers = [
    {
      'id': 'temperature',
      'name': 'Temperature',
      'icon': Icons.thermostat,
      'color': AppColors.warning,
    },
    {
      'id': 'precipitation',
      'name': 'Precipitation',
      'icon': Icons.water_drop,
      'color': AppColors.info,
    },
    {
      'id': 'wind',
      'name': 'Wind Speed',
      'icon': Icons.air,
      'color': AppColors.success,
    },
    {
      'id': 'pressure',
      'name': 'Pressure',
      'icon': Icons.speed,
      'color': AppColors.primary,
    },
  ];

  final List<Map<String, dynamic>> sampleLocations = [
    {
      'name': 'New York',
      'lat': 40.7128,
      'lon': -74.0060,
      'temp': 22,
      'condition': 'sunny'
    },
    {
      'name': 'London',
      'lat': 51.5074,
      'lon': -0.1278,
      'temp': 18,
      'condition': 'cloudy'
    },
    {
      'name': 'Tokyo',
      'lat': 35.6762,
      'lon': 139.6503,
      'temp': 25,
      'condition': 'clear'
    },
    {
      'name': 'Sydney',
      'lat': -33.8688,
      'lon': 151.2093,
      'temp': 20,
      'condition': 'rainy'
    },
    {
      'name': 'Dubai',
      'lat': 25.2048,
      'lon': 55.2708,
      'temp': 35,
      'condition': 'sunny'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
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
            child: Column(
              children: [
                _buildLayerSelector(),
                Expanded(
                  child: _buildMap(),
                ),
                _buildMapControls(),
              ],
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
        'Weather Map',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.layers),
          onPressed: () => _showLayerOptions(),
        ),
        IconButton(
          icon: const Icon(Icons.my_location),
          onPressed: () => _centerOnCurrentLocation(),
        ),
      ],
    );
  }

  Widget _buildLayerSelector() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: weatherLayers.length,
        itemBuilder: (context, index) {
          final layer = weatherLayers[index];
          final isSelected = layer['id'] == selectedLayer;

          return GestureDetector(
            onTap: () => setState(() => selectedLayer = layer['id']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [
                          layer['color'],
                          layer['color'].withOpacity(0.7)
                        ],
                      )
                    : null,
                color: isSelected ? null : AppColors.cardBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? layer['color'] : AppColors.cardBorder,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    layer['icon'],
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    layer['name'],
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMap() {
    return Container(
      margin: const EdgeInsets.all(16),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background map (simulated)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: AppColors.getWeatherGradient('clear', true),
                ),
              ),
            ),

            // Weather overlay pattern
            _buildWeatherOverlay(),

            // Location markers
            ...sampleLocations
                .map((location) => _buildLocationMarker(location)),

            // Legend
            Positioned(
              top: 16,
              right: 16,
              child: _buildLegend(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherOverlay() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: CustomPaint(
        painter: WeatherOverlayPainter(selectedLayer),
        size: Size.infinite,
      ),
    );
  }

  Widget _buildLocationMarker(Map<String, dynamic> location) {
    final position = _getMarkerPosition(location['lat'], location['lon']);

    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onTap: () => _showLocationDetails(location),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary, width: 2),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                location['name'],
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                '${location['temp']}°',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedLayer.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          _buildLegendItem('High', AppColors.error),
          _buildLegendItem('Medium', AppColors.warning),
          _buildLegendItem('Low', AppColors.success),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(Icons.zoom_in, () => _zoomIn()),
          _buildControlButton(Icons.zoom_out, () => _zoomOut()),
          _buildControlButton(Icons.refresh, () => _refreshMap()),
          _buildControlButton(Icons.fullscreen, () => _toggleFullscreen()),
        ],
      ),
    );
  }

  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.textPrimary),
        onPressed: onPressed,
      ),
    );
  }

  Offset _getMarkerPosition(double lat, double lon) {
    // Simplified positioning for demo purposes
    return Offset(
      (lon + 180) * 2, // Simplified longitude to x conversion
      (90 - lat) * 2, // Simplified latitude to y conversion
    );
  }

  void _showLayerOptions() {
    // Implementation for layer options
  }

  void _centerOnCurrentLocation() {
    // Implementation for centering on current location
  }

  void _showLocationDetails(Map<String, dynamic> location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBackground,
        title: Text(location['name']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Temperature: ${location['temp']}°C'),
            Text('Condition: ${location['condition']}'),
            Text('Coordinates: ${location['lat']}, ${location['lon']}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _zoomIn() => setState(() => mapZoom = (mapZoom * 1.2).clamp(0.5, 3.0));
  void _zoomOut() => setState(() => mapZoom = (mapZoom / 1.2).clamp(0.5, 3.0));
  void _refreshMap() {
    _animationController.reset();
    _animationController.forward();
  }

  void _toggleFullscreen() {
    // Implementation for fullscreen toggle
  }
}

class WeatherOverlayPainter extends CustomPainter {
  final String layer;

  WeatherOverlayPainter(this.layer);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.blue.withOpacity(0.3);

    // Draw weather pattern based on selected layer
    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 15; j++) {
        final x = (size.width / 20) * i;
        final y = (size.height / 15) * j;

        paint.color = _getLayerColor(i, j).withOpacity(0.4);
        canvas.drawCircle(Offset(x, y), 8, paint);
      }
    }
  }

  Color _getLayerColor(int x, int y) {
    switch (layer) {
      case 'temperature':
        return x > 10 ? AppColors.error : AppColors.warning;
      case 'precipitation':
        return y > 7 ? AppColors.info : AppColors.success;
      case 'wind':
        return (x + y) % 3 == 0 ? AppColors.warning : AppColors.success;
      case 'pressure':
        return x % 2 == 0 ? AppColors.primary : AppColors.info;
      default:
        return AppColors.textSecondary;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
