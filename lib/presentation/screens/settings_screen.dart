import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/app_settings_provider.dart';
import '../widgets/weather_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(AppStrings.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          const WeatherBackground(),
          SafeArea(
            child: Consumer<AppSettingsProvider>(
              builder: (context, settings, child) {
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    // Units Section
                    _SettingsSection(
                      title: 'Units',
                      children: [
                        _DropdownSettingsTile(
                          title: AppStrings.temperatureUnit,
                          value: settings.temperatureUnit,
                          items: const [
                            DropdownMenuItem(
                                value: 'metric', child: Text('Celsius (°C)')),
                            DropdownMenuItem(
                                value: 'imperial',
                                child: Text('Fahrenheit (°F)')),
                            DropdownMenuItem(
                                value: 'kelvin', child: Text('Kelvin (K)')),
                          ],
                          onChanged: (value) =>
                              settings.setTemperatureUnit(value!),
                        ),
                        _DropdownSettingsTile(
                          title: AppStrings.windSpeedUnit,
                          value: settings.windSpeedUnit,
                          items: const [
                            DropdownMenuItem(value: 'kmh', child: Text('km/h')),
                            DropdownMenuItem(value: 'mph', child: Text('mph')),
                            DropdownMenuItem(value: 'ms', child: Text('m/s')),
                          ],
                          onChanged: (value) =>
                              settings.setWindSpeedUnit(value!),
                        ),
                        _DropdownSettingsTile(
                          title: AppStrings.pressureUnit,
                          value: settings.pressureUnit,
                          items: const [
                            DropdownMenuItem(value: 'hPa', child: Text('hPa')),
                            DropdownMenuItem(
                                value: 'inHg', child: Text('inHg')),
                          ],
                          onChanged: (value) =>
                              settings.setPressureUnit(value!),
                        ),
                        _DropdownSettingsTile(
                          title: AppStrings.distanceUnit,
                          value: settings.distanceUnit,
                          items: const [
                            DropdownMenuItem(
                                value: 'km', child: Text('Kilometers')),
                            DropdownMenuItem(
                                value: 'miles', child: Text('Miles')),
                          ],
                          onChanged: (value) =>
                              settings.setDistanceUnit(value!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Appearance Section
                    _SettingsSection(
                      title: 'Appearance',
                      children: [
                        _SwitchSettingsTile(
                          title: AppStrings.darkMode,
                          subtitle: 'Use dark theme',
                          value: settings.darkMode,
                          onChanged: (value) => settings.setDarkMode(value),
                        ),
                        _DropdownSettingsTile(
                          title: AppStrings.timeFormat,
                          value: settings.timeFormat,
                          items: const [
                            DropdownMenuItem(
                                value: '24h', child: Text('24-hour')),
                            DropdownMenuItem(
                                value: '12h', child: Text('12-hour')),
                          ],
                          onChanged: (value) => settings.setTimeFormat(value!),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Preferences Section
                    _SettingsSection(
                      title: 'Preferences',
                      children: [
                        _SwitchSettingsTile(
                          title: AppStrings.autoLocation,
                          subtitle: 'Automatically detect location',
                          value: settings.autoLocation,
                          onChanged: (value) => settings.setAutoLocation(value),
                        ),
                        _SwitchSettingsTile(
                          title: AppStrings.notifications,
                          subtitle: 'Receive weather notifications',
                          value: settings.notifications,
                          onChanged: (value) =>
                              settings.setNotifications(value),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Saved Locations Section
                    if (settings.savedLocations.isNotEmpty)
                      _SettingsSection(
                        title: 'Saved Locations',
                        children: settings.savedLocations.map((location) {
                          return _LocationSettingsTile(
                            location: location,
                            onRemove: () => settings.removeLocation(location),
                          );
                        }).toList(),
                      ),

                    const SizedBox(height: 24),

                    // About Section
                    _SettingsSection(
                      title: 'About',
                      children: [
                        _InfoSettingsTile(
                          title: 'Version',
                          value: '1.0.0',
                          icon: Icons.info_outline,
                        ),
                        _InfoSettingsTile(
                          title: 'Built with',
                          value: 'Flutter & OpenWeatherMap API',
                          icon: Icons.code,
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Reset Button
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _showResetDialog(context, settings),
                        icon: const Icon(Icons.restore),
                        label: const Text('Reset to Defaults'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: AppColors.textPrimary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context, AppSettingsProvider settings) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.cardBackground,
          title: const Text('Reset Settings'),
          content: const Text(
            'This will reset all settings to their default values. This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                settings.resetToDefaults();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Settings reset to defaults'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.textPrimary,
              ),
              child: const Text('Reset'),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.cardBorder,
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}

class _SwitchSettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchSettingsTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }
}

class _DropdownSettingsTile extends StatelessWidget {
  final String title;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const _DropdownSettingsTile({
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: DropdownButton<String>(
        value: value,
        items: items,
        onChanged: onChanged,
        underline: const SizedBox(),
        dropdownColor: AppColors.cardBackground,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textPrimary,
            ),
      ),
    );
  }
}

class _InfoSettingsTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoSettingsTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        value,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
    );
  }
}

class _LocationSettingsTile extends StatelessWidget {
  final dynamic location; // Location model
  final VoidCallback onRemove;

  const _LocationSettingsTile({
    required this.location,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.location_on,
        color: AppColors.textSecondary,
      ),
      title: Text(
        location.name,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        location.displayName,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
      ),
      trailing: IconButton(
        icon: const Icon(
          Icons.delete_outline,
          color: AppColors.error,
        ),
        onPressed: onRemove,
      ),
    );
  }
}
