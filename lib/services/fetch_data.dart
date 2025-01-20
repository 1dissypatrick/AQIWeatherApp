import 'dart:convert';
import 'dart:developer';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'package:your_project_name/models/air_quality.dart';
import 'package:http/http.dart' as http;
import '/constants/constants.dart';

Future<AirQuality?> fetchData() async {
  try {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();

    var url = Uri.parse(
        'https://api.waqi.info/feed/geo:${position.latitude};${position.longitude}/?token=${Constants.API_KEY}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse['data'] != null) {
        AirQuality airQuality = AirQuality.fromJson(jsonResponse);

        if (airQuality.aqi >= 0 && airQuality.aqi <= 50) {
          airQuality.message = "Air quality is good, no pollution risk.";
        } else if (airQuality.aqi >= 51 && airQuality.aqi <= 100) {
          airQuality.message = "Air quality is acceptable; minor health concern for sensitive people.";
        } else if (airQuality.aqi >= 101 && airQuality.aqi <= 150) {
          airQuality.message = "Sensitive groups may experience health effects.";
        } else if (airQuality.aqi >= 151 && airQuality.aqi <= 200) {
          airQuality.message = "Everyone may experience health effects; sensitive groups more serious.";
        } else if (airQuality.aqi >= 201 && airQuality.aqi <= 300) {
          airQuality.message = "Health warning: entire population at risk.";
        } else if (airQuality.aqi >= 300) {
          airQuality.message = "Health alert: serious health effects for everyone.";
        }

        // Store the AQI value locally
        await storeAQI(airQuality);

        print(airQuality);
        return airQuality;
      } else {
        return null;
      }
    }
    return null;
  } catch (e) {
    log(e.toString());
    rethrow;
  }
}

Future<void> storeAQI(AirQuality airQuality) async {
  final prefs = await SharedPreferences.getInstance();
  List<String> aqiHistory = prefs.getStringList('aqiHistory') ?? [];

  // Parse the existing history
  List<Map<String, dynamic>> parsedHistory = aqiHistory.map((aqiData) {
    return jsonDecode(aqiData) as Map<String, dynamic>;
  }).toList();

  // Check if an entry with the same date already exists
  String currentDate = airQuality.updateTime.split('T')[0];
  bool exists = parsedHistory.any((entry) => entry['updateTime'].split('T')[0] == currentDate);

  // If it doesn't exist, add the new entry
  if (!exists) {
    Map<String, dynamic> aqiData = {
      'aqi': airQuality.aqi,
      'cityName': airQuality.cityName, // Include city name
      'updateTime': airQuality.updateTime,
    };
    aqiHistory.add(jsonEncode(aqiData));
    await prefs.setStringList('aqiHistory', aqiHistory);
  }
}

Future<List<AirQuality>> fetchStoredAQIHistory() async {
  final prefs = await SharedPreferences.getInstance();
  List<String> aqiHistory = prefs.getStringList('aqiHistory') ?? [];

  List<AirQuality> airQualityHistory = aqiHistory.map((aqiData) {
    Map<String, dynamic> data = jsonDecode(aqiData);
    return AirQuality(
      aqi: data['aqi'],
      cityName: data['cityName'] ?? 'Unknown city', // Retrieve city name
      updateTime: data['updateTime'] ?? 'Unknown time',
    );
  }).toList();

  return airQualityHistory;
}

Future<List<AirQuality>> fetchDataForCities(List<String> cities) async {
  List<AirQuality> airQualityList = [];
  for (String city in cities) {
    var url = Uri.parse(
        'https://api.waqi.info/feed/$city/?token=${Constants.API_KEY}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = jsonDecode(response.body);
      if (jsonResponse['data'] != null) {
        AirQuality airQuality = AirQuality.fromJson(jsonResponse);
        airQualityList.add(airQuality);
      }
    }
  }
  // Sort by AQI
  airQualityList.sort((a, b) => a.aqi.compareTo(b.aqi));
  return airQualityList;
}
