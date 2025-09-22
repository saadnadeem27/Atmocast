# 🌤️ Atmocast - Premium Weather App

A beautiful and professional Flutter weather application with premium UI design and comprehensive functionality.

## ✨ Features

### 🏠 Core Functionality
- **Real-time Weather Data**: Current weather conditions with live updates
- **Location Services**: GPS-based location detection and search
- **Multi-location Support**: Save and track multiple cities
- **Detailed Forecasts**: Hourly and 7-day weather predictions
- **Comprehensive Details**: Temperature, humidity, wind, pressure, UV index, and more

### 🎨 Premium Design
- **Material 3 Design**: Modern and consistent UI patterns
- **Weather-based Backgrounds**: Dynamic gradients that change with conditions
- **Glass Morphism Effects**: Premium card designs with blur effects
- **Smooth Animations**: Fluid transitions and micro-interactions
- **Dark/Light Theme**: Adaptive themes based on preferences

### ⚙️ Advanced Settings
- **Unit Customization**: Temperature (°C, °F, K), wind speed, pressure
- **Time Formats**: 12-hour and 24-hour display options
- **Notifications**: Weather alerts and updates
- **Auto Location**: Automatic location detection preferences

### 🚀 Technical Excellence
- **State Management**: Provider pattern for reactive UI
- **API Integration**: OpenWeatherMap API with error handling
- **Performance Optimized**: Caching and efficient data loading
- **Cross-platform**: Supports Web, Android, iOS, Windows, macOS, Linux

## 🛠️ Technologies Used

- **Framework**: Flutter 3.x
- **State Management**: Provider
- **API**: OpenWeatherMap API
- **Location**: Geolocator & Geocoding
- **UI**: Material 3, Google Fonts, Custom Animations
- **Storage**: SharedPreferences
- **HTTP Client**: HTTP package

## 🎯 Project Structure

```
lib/
├── core/
│   ├── constants/          # App colors, strings, themes
│   └── theme/             # App theme configuration
├── data/
│   ├── models/            # Weather data models
│   └── services/          # API and location services
├── providers/             # State management
└── presentation/
    ├── screens/           # Main app screens
    └── widgets/           # Reusable UI components
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- OpenWeatherMap API key

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/atmo_cast.git
   cd atmo_cast
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **API Configuration**
   - Get your free API key from [OpenWeatherMap](https://openweathermap.org/api)
   - Update the API key in `lib/core/constants/app_constants.dart`

4. **Run the app**
   ```bash
   # For web
   flutter run -d chrome
   
   # For mobile (with device connected)
   flutter run
   
   # For desktop
   flutter run -d windows  # or macos, linux
   ```

## 📱 Screenshots

*Add your app screenshots here*

## 🌟 Key Highlights

- **No UI Compromises**: Premium design with attention to detail
- **Full Functionality**: Complete weather app with all essential features
- **Professional Quality**: Production-ready code with comprehensive error handling
- **Responsive Design**: Beautiful on all screen sizes and platforms
- **Performance Optimized**: Efficient state management and caching

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- OpenWeatherMap for weather data API
- Flutter team for the amazing framework
- Material Design for design guidelines

---

**Developed with ❤️ using Flutter**
