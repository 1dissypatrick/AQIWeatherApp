import 'package:flutter/material.dart';
import '../models/air_quality.dart';
import '../services/fetch_data.dart';

class AirQualityHistoryScreen extends StatelessWidget {
  const AirQualityHistoryScreen({super.key});

  Future<List<AirQuality>> _fetchAirQualityHistory() async {
    return await fetchStoredAQIHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Air Quality History'),
      ),
      body: FutureBuilder<List<AirQuality>>(
        future: _fetchAirQualityHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          }

          final airQualityHistory = snapshot.data!;
          // Reverse the list to show the newest data at the top
          final reversedAirQualityHistory = airQualityHistory.reversed.toList();

          return ListView.builder(
            itemCount: reversedAirQualityHistory.length,
            itemBuilder: (context, index) {
              final airQuality = reversedAirQualityHistory[index];
              return ListTile(
                title: Text('Date: ${airQuality.updateTime}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text('AQI: ${airQuality.aqi}'),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
