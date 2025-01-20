import 'package:flutter/material.dart';
import '/models/weather.dart';
import '/models/air_quality.dart';
import '/services/api_helper.dart'; // Import ApiHelper
import '/constants/text_styles.dart';
import '/constants/app_colors.dart';
import '/views/gradient_container.dart';
import '/widgets/round_text_field.dart';
import '/views/famous_cities_weather.dart'; // Import FamousCitiesWeather
import '/utils/get_weather_icons.dart'; // Import getWeatherIcon
import '/screens/aqi_ranking_screen.dart'; // Import AQIRankingScreen
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/constants/constants.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  late final TextEditingController _searchController;
  Weather? _weather;
  AirQuality? _airQuality;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<AirQuality?> fetchAQI(String cityName) async {
    final url = Uri.parse('https://api.waqi.info/feed/$cityName/?token=${Constants.API_KEY}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['data'] != null) {
        return AirQuality.fromJson(jsonResponse);
      } else {
        return null;
      }
    } else {
      print('Failed to load AQI data');
      return null;
    }
  }

  void _searchWeatherAndAQI() async {
    final cityName = _searchController.text;
    final weather = await ApiHelper.getWeatherByCityName(cityName: cityName);
    final airQuality = await fetchAQI(cityName);

    setState(() {
      _weather = weather;
      _airQuality = airQuality;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Air quality icon
            Icon(
              Icons.air, // You can choose a different icon
              size: 24,
              color: Colors.green, // Change color as needed
            ),
            const SizedBox(width: 8), // Spacing between icon and text
            Text(
              'Air Quality Monitoring',
              style: TextStyle(
                fontSize: 24, // Increased font size
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent, // Change color as needed
              ),
            ),
            const SizedBox(width: 8), // Additional spacing
            // Additional decorative icon
            Icon(
              Icons.cloud, // You can choose a different icon
              size: 24,
              color: Colors.blue, // Change color as needed
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Search'),
            Tab(text: 'AQI Ranking'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          GradientContainer(
            children: [
              // Page title
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Pick Location',
                  style: TextStyles.h1,
                ),
              ),

              const SizedBox(height: 20),

              // Page subtitle
              const Text(
                'Find the area or city that you want to know the detailed weather info at this time',
                style: TextStyles.subtitleText,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Pick location row
              Row(
                children: [
                  // Choose city text field
                  Expanded(
                    child: RoundTextField(controller: _searchController),
                  ),
                  const SizedBox(width: 15),

                  ElevatedButton(
                    onPressed: _searchWeatherAndAQI,
                    child: const Text('Search'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Display weather info
              if (_weather != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: AppColors.accentBlue,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Weather details
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_weather!.name}',
                            style: TextStyles.h2,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${_weather!.main.temp}°C',
                            style: TextStyles.h2,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            '${_weather!.weather[0].description}',
                            style: TextStyles.h2,
                          ),
                          if (_airQuality != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              'AQI: ${_airQuality!.aqi} ${getAQIEmoji(_airQuality!.aqi)}',
                              style: TextStyles.h2.copyWith(
                                color: getAQIColor(_airQuality!.aqi),
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Weather icon
                      Image.asset(
                        getWeatherIcon(weatherCode: _weather!.weather[0].id),
                        width: 100, // Increase the width to make the icon bigger
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 30),

              // Title for famous cities weather
              const Align(
                alignment: Alignment.center,
                child: Text(
                  'Famous Cities',
                  style: TextStyles.h1,
                ),
              ),

              const SizedBox(height: 20),

              // Famous cities weather
              const FamousCitiesWeather(),
            ],
          ),
          AQIRankingScreen(),
        ],
      ),
    );
  }
}

// Function to get AQI color
Color getAQIColor(int aqi) {
  if (aqi <= 50) {
    return Colors.green;
  } else if (aqi <= 100) {
    return Colors.yellow;
  } else if (aqi <= 150) {
    return Colors.orange;
  } else if (aqi <= 200) {
    return Colors.red;
  } else if (aqi <= 300) {
    return Colors.purple;
  } else {
    return Colors.brown;
  }
}

// Function to get AQI emoji
String getAQIEmoji(int aqi) {
  if (aqi <= 50) {
    return '😊';
  } else if (aqi <= 100) {
    return '😐';
  } else if (aqi <= 150) {
    return '😷';
  } else if (aqi <= 200) {
    return '🤢';
  } else if (aqi <= 300) {
    return '🤮';
  } else {
    return '☠️';
  }
}
