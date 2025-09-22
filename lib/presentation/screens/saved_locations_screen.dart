import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../data/models/location.dart';
import '../widgets/weather_background.dart';

class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({super.key});

  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<AnimationController> _itemAnimationControllers;

  final List<Map<String, dynamic>> savedLocations = [
    {
      'location': Location(
        name: 'New York',
        country: 'United States',
        latitude: 40.7128,
        longitude: -74.0060,
      ),
      'temperature': 22,
      'condition': 'Sunny',
      'emoji': '☀️',
      'isFavorite': true,
    },
    {
      'location': Location(
        name: 'London',
        country: 'United Kingdom',
        latitude: 51.5074,
        longitude: -0.1278,
      ),
      'temperature': 18,
      'condition': 'Cloudy',
      'emoji': '☁️',
      'isFavorite': false,
    },
    {
      'location': Location(
        name: 'Tokyo',
        country: 'Japan',
        latitude: 35.6762,
        longitude: 139.6503,
      ),
      'temperature': 25,
      'condition': 'Clear',
      'emoji': '🌤️',
      'isFavorite': true,
    },
    {
      'location': Location(
        name: 'Sydney',
        country: 'Australia',
        latitude: -33.8688,
        longitude: 151.2093,
      ),
      'temperature': 20,
      'condition': 'Rainy',
      'emoji': '🌧️',
      'isFavorite': false,
    },
    {
      'location': Location(
        name: 'Dubai',
        country: 'United Arab Emirates',
        latitude: 25.2048,
        longitude: 55.2708,
      ),
      'temperature': 35,
      'condition': 'Hot',
      'emoji': '🔥',
      'isFavorite': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _itemAnimationControllers = List.generate(
      savedLocations.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      ),
    );

    _animationController.forward();
    for (int i = 0; i < _itemAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 100), () {
        if (mounted) _itemAnimationControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (final controller in _itemAnimationControllers) {
      controller.dispose();
    }
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
                _buildHeader(),
                Expanded(
                  child: _buildLocationsList(),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildAddLocationFab(),
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
        'Saved Locations',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => _toggleEditMode(),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return FadeTransition(
      opacity: _animationController,
      child: Container(
        margin: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Locations',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${savedLocations.length} saved locations',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Synced',
                    style: TextStyle(
                      color: AppColors.success,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: savedLocations.length,
      itemBuilder: (context, index) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: _itemAnimationControllers[index],
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: _itemAnimationControllers[index],
            child: _buildLocationCard(savedLocations[index], index),
          ),
        );
      },
    );
  }

  Widget _buildLocationCard(Map<String, dynamic> locationData, int index) {
    final location = locationData['location'] as Location;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        border: Border.all(
          color: locationData['isFavorite']
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.cardBorder,
          width: locationData['isFavorite'] ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _selectLocation(locationData),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Weather emoji and temperature
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text(
                        locationData['emoji'],
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${locationData['temperature']}°',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 16),

                // Location details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              location.name,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (locationData['isFavorite'])
                            const Icon(
                              Icons.favorite,
                              color: AppColors.primary,
                              size: 20,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        location.country,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  _getConditionColor(locationData['condition'])
                                      .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              locationData['condition'],
                              style: TextStyle(
                                color: _getConditionColor(
                                    locationData['condition']),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'Updated 5m ago',
                            style: const TextStyle(
                              color: AppColors.textTertiary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Action buttons
                Column(
                  children: [
                    IconButton(
                      icon: Icon(
                        locationData['isFavorite']
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: locationData['isFavorite']
                            ? AppColors.primary
                            : AppColors.textSecondary,
                      ),
                      onPressed: () => _toggleFavorite(index),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: () => _showLocationOptions(index),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddLocationFab() {
    return ScaleTransition(
      scale: _animationController,
      child: FloatingActionButton.extended(
        onPressed: _addNewLocation,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_location),
        label: const Text('Add Location'),
      ),
    );
  }

  Color _getConditionColor(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
      case 'hot':
        return AppColors.warning;
      case 'cloudy':
        return AppColors.info;
      case 'rainy':
        return AppColors.primary;
      default:
        return AppColors.textSecondary;
    }
  }

  void _toggleEditMode() {
    // Implementation for edit mode
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Edit mode toggled')),
    );
  }

  void _selectLocation(Map<String, dynamic> locationData) {
    Navigator.pop(context, locationData['location']);
  }

  void _toggleFavorite(int index) {
    setState(() {
      savedLocations[index]['isFavorite'] =
          !savedLocations[index]['isFavorite'];
    });
  }

  void _showLocationOptions(int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit, color: AppColors.primary),
              title: const Text('Edit Location'),
              onTap: () {
                Navigator.pop(context);
                _editLocation(index);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.notifications, color: AppColors.warning),
              title: const Text('Set Alerts'),
              onTap: () {
                Navigator.pop(context);
                _setAlerts(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: AppColors.error),
              title: const Text('Remove Location'),
              onTap: () {
                Navigator.pop(context);
                _removeLocation(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _addNewLocation() {
    // Implementation for adding new location
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add new location')),
    );
  }

  void _editLocation(int index) {
    // Implementation for editing location
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit ${savedLocations[index]['location'].name}')),
    );
  }

  void _setAlerts(int index) {
    // Implementation for setting alerts
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Set alerts for ${savedLocations[index]['location'].name}')),
    );
  }

  void _removeLocation(int index) {
    final locationName = savedLocations[index]['location'].name;
    setState(() {
      savedLocations.removeAt(index);
      _itemAnimationControllers[index].dispose();
      _itemAnimationControllers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$locationName removed from saved locations')),
    );
  }
}
