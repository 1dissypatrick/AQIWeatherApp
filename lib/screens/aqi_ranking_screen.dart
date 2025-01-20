import 'package:flutter/material.dart';
import 'package:your_project_name/services/fetch_data.dart';
import 'package:your_project_name/models/air_quality.dart';

class AQIRankingScreen extends StatefulWidget {
  const AQIRankingScreen({super.key});

  @override
  State<AQIRankingScreen> createState() => _AQIRankingScreenState();
}

class _AQIRankingScreenState extends State<AQIRankingScreen> {
  late Future<List<AirQuality>> _futureAirQualityList;
  late String _lastUpdated;

  @override
  void initState() {
    super.initState();
    _futureAirQualityList = fetchDataForCities([
      'Beijing', 'New York', 'Tokyo', 'Paris', 'London', 'Bangkok', 'Dubai', 'Singapore',
      'Los Angeles', 'Hong Kong', 'Sydney', 'Rome', 'San Francisco', 'Moscow', 'Madrid',
      'Seoul', 'Sao Paulo', 'Mexico City', 'Istanbul', 'Toronto'
    ]);
  }


  Color _getAQIColor(int aqi) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<List<AirQuality>>(
          future: _futureAirQualityList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text(
                'Loading...',
                textAlign: TextAlign.center,
              );
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text(
                'Error',
                textAlign: TextAlign.center,
              );
            } else {
              List<AirQuality> airQualityList = snapshot.data!;
              _lastUpdated = airQualityList.first.updateTime;
              return Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.access_time),
                  const SizedBox(width: 8),
                  Text(
                    'Realtime $_lastUpdated',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              );
            }
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<AirQuality>>(
              future: _futureAirQualityList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  List<AirQuality> airQualityList = snapshot.data!;
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('Ranking')),
                          DataColumn(label: Text('Popular City')),
                          DataColumn(label: Text('AQI')),
                        ],
                        rows: airQualityList.asMap().entries.map((entry) {
                          int index = entry.key + 1;
                          AirQuality airQuality = entry.value;
                          return DataRow(
                            cells: [
                              DataCell(Text(index.toString())),
                              DataCell(
                                Container(
                                  width: 150,
                                  child: Text(
                                    airQuality.cityName,
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                              DataCell(Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: _getAQIColor(airQuality.aqi),
                                  borderRadius: BorderRadius.circular(8), // Rounded corners
                                ),
                                child: Center(
                                  child: Text(
                                    airQuality.aqi.toString(),
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
