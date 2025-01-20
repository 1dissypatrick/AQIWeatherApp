import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/air_quality.dart';
import '../services/notification_service.dart';
import 'threshold_screen.dart';
import '../constants/app_colors.dart';
import 'search_screen.dart';
import 'air_quality_screen.dart';
import 'weather_screen/weather_screen.dart';
import '../services/api_helper.dart';
import 'forecast_report_screen.dart';
import 'profile.dart';
import '../services/fetch_data.dart'; // Import fetchData
import 'tips_screen.dart'; // Import TipsScreen
import 'heart_rate_monitor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  final _screens = const [
    AirQualityScreen(),
    WeatherScreen(),
    SearchScreen(),
    HeartRateMonitorScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    ApiHelper.getCurrentWeather();
    NotificationService.initNotifications();
    _startAQICheck();
  }

  void _startAQICheck() async {
    final prefs = await SharedPreferences.getInstance();
    int userThreshold = prefs.getInt('threshold') ?? 100;

    Timer.periodic(Duration(minutes: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }
      AirQuality? airQuality = await fetchData();
      if (airQuality != null && airQuality.aqi > userThreshold) {
        NotificationService.showNotification(airQuality.aqi);
      }
    });
  }

  @override
  void dispose() {
    // Ensure to cancel any active timers or streams
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _screens[_currentPageIndex],
          Positioned(
            top: 64.0, // Adjust the value to lower the button
            right: 16.0,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThresholdScreen()),
                );
              },
              mini: true, // Make the button smaller
              child: Icon(Icons.notifications),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: const NavigationBarThemeData(
          backgroundColor: AppColors.secondaryBlack,
        ),
        child: NavigationBar(
          selectedIndex: _currentPageIndex,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          indicatorColor: Colors.transparent,
          onDestinationSelected: (index) =>
              setState(() => _currentPageIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.home, color: Colors.white),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.wb_sunny_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.wb_sunny, color: Colors.white),
              label: 'Weather',
            ),
            NavigationDestination(
              icon: Icon(Icons.search_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.search, color: Colors.white),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_outline, color: Colors.white),
              selectedIcon: Icon(Icons.favorite, color: Colors.white),
              label: 'Sensor',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outlined, color: Colors.white),
              selectedIcon: Icon(Icons.person, color: Colors.white),
              label: 'Profile',
            ),
          ],
        ),
      ),
      persistentFooterButtons: [
        SizedBox(
          height: 33.0,
          width: 200.0,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TipsScreen()),
              );
            },
            child: Text('Tips for Improving Air Quality'),
          ),
        ),
      ],
    );
  }
}
