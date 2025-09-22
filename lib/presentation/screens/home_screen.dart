import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/weather_provider.dart';
import '../widgets/weather_background.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/hourly_forecast_list.dart';
import '../widgets/daily_forecast_list.dart';
import '../widgets/weather_details_grid.dart';
import '../widgets/loading_shimmer.dart';
import '../widgets/error_widget.dart';
import 'location_search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _refreshAnimationController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    super.dispose();
  }

  Future<void> _refreshWeather() async {
    _refreshAnimationController.forward();
    try {
      await context.read<WeatherProvider>().refreshWeatherData();
    } finally {
      _refreshAnimationController.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          return Stack(
            children: [
              // Background
              const WeatherBackground(),

              // Content
              SafeArea(
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  onRefresh: _refreshWeather,
                  color: AppColors.primary,
                  backgroundColor: AppColors.cardBackground,
                  child: _buildContent(weatherProvider),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Consumer<WeatherProvider>(
        builder: (context, weatherProvider, child) {
          final location = weatherProvider.currentLocation;
          return Column(
            children: [
              Text(
                location?.name ?? AppStrings.appName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (location != null)
                Text(
                  location.country,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
            ],
          );
        },
      ),
      leading: IconButton(
        icon: const Icon(Icons.location_on_outlined),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const LocationSearchScreen(),
            ),
          );
        },
      ),
      actions: [
        Consumer<WeatherProvider>(
          builder: (context, weatherProvider, child) {
            return RotationTransition(
              turns: _refreshAnimationController,
              child: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: weatherProvider.isLoading ? null : _refreshWeather,
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent(WeatherProvider weatherProvider) {
    if (weatherProvider.hasError) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: WeatherErrorWidget(
              message: weatherProvider.errorMessage ?? AppStrings.errorOccurred,
              onRetry: _refreshWeather,
            ),
          ),
        ],
      );
    }

    if (weatherProvider.isLoading && !weatherProvider.hasData) {
      return const CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: LoadingShimmer(),
          ),
        ],
      );
    }

    if (!weatherProvider.hasData) {
      return CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverFillRemaining(
            child: WeatherErrorWidget(
              message: AppStrings.weatherDataUnavailable,
              onRetry: _refreshWeather,
            ),
          ),
        ],
      );
    }

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Current Weather
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: CurrentWeatherCard(
              weatherData: weatherProvider.currentWeather!,
              isLoading: weatherProvider.isLoading,
            ),
          ),
        ),

        // Hourly Forecast
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.hourlyForecast,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 140,
                  child: HourlyForecastList(
                    hourlyForecast: weatherProvider.next24HoursForecast,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Weather Details
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: WeatherDetailsGrid(
              weatherData: weatherProvider.currentWeather!,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),

        // Daily Forecast
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.dailyForecast,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 12),
                DailyForecastList(
                  dailyForecast: weatherProvider.dailyForecast,
                ),
              ],
            ),
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}
