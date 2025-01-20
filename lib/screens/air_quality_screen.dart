import 'package:flutter/material.dart';
import '/models/air_quality.dart';
import '/views/gradient_container.dart';
import '/services/fetch_data.dart'; // Assuming your fetchData function is in this file
import 'air_quality_history_screen.dart'; // Import AirQualityHistoryScreen
import '/constants/text_styles.dart';

class AirQualityScreen extends StatelessWidget {
  const AirQualityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      children: [
        // Page Title
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Air Quality',
            style: TextStyles.h1,
          ),
        ),
        const SizedBox(height: 30),

        FutureBuilder<AirQuality?>(
          future: fetchData(), // Fetch air quality data
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data != null) {
              return _buildAirQualityDetails(context, snapshot.data!);
            } else {
              return const Center(child: Text('No data available'));
            }
          },
        ),
      ],
    );
  }

  Widget _buildAirQualityDetails(BuildContext context, AirQuality airQuality) {
    Color aqiColor = _getAQIColor(airQuality.aqi);
    IconData aqiIcon = _getAQIIcon(airQuality.aqi);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'City: ${airQuality.cityName}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(aqiIcon, color: aqiColor, size: 30),
                  const SizedBox(width: 10),
                  Text(
                    'AQI: ${airQuality.aqi}',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: aqiColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                airQuality.message ?? 'No message available',
                style: TextStyle(
                  fontSize: 16,
                  color: aqiColor,
                ),
              ),
              const Divider(height: 40),
              _buildIAQILine('CO', airQuality.co, 'mg/m³'),
              _buildIAQILine('NO2', airQuality.no2, 'µg/m³'),
              _buildIAQILine('SO2', airQuality.so2, 'µg/m³'),
              _buildIAQILine('O3', airQuality.o3, 'µg/m³'),
              _buildIAQILine('PM2.5', airQuality.pm25, 'µg/m³'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildIAQILine('PM10', airQuality.pm10, 'µg/m³'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AirQualityHistoryScreen()),
                      );
                    },
                    child: Text('AQI History'),
                  ),
                ],
              ),

            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Last updated: ${airQuality.updateTime}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Color _getAQIColor(int aqi) {
    if (aqi >= 0 && aqi <= 50) {
      return Colors.green;
    } else if (aqi >= 51 && aqi <= 100) {
      return Colors.yellow;
    } else if (aqi >= 101 && aqi <= 150) {
      return Colors.orange;
    } else if (aqi >= 151 && aqi <= 200) {
      return Colors.red;
    } else if (aqi >= 201 && aqi <= 300) {
      return Colors.purple;
    } else {
      return Colors.brown;
    }
  }

  IconData _getAQIIcon(int aqi) {
    if (aqi >= 0 && aqi <= 50) {
      return Icons.sentiment_very_satisfied;
    } else if (aqi >= 51 && aqi <= 100) {
      return Icons.sentiment_satisfied;
    } else if (aqi >= 101 && aqi <= 150) {
      return Icons.sentiment_neutral;
    } else if (aqi >= 151 && aqi <= 200) {
      return Icons.sentiment_dissatisfied;
    } else if (aqi >= 201 && aqi <= 300) {
      return Icons.sentiment_very_dissatisfied;
    } else {
      return Icons.error;
    }
  }

  Widget _buildIAQILine(String title, double? value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title: ${value != null ? '$value $unit' : 'Unknown'}'),
        const Divider(height: 20),
      ],
    );
  }
}
