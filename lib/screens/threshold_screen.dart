import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/fetch_data.dart'; // Import fetchData
import '../services/notification_service.dart'; // Import NotificationService

class ThresholdScreen extends StatefulWidget {
  @override
  _ThresholdScreenState createState() => _ThresholdScreenState();
}

class _ThresholdScreenState extends State<ThresholdScreen> {
  int _threshold = 100;
  String _saveMessage = '';

  @override
  void initState() {
    super.initState();
    _loadThreshold();
  }

  Future<void> _loadThreshold() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _threshold = prefs.getInt('threshold') ?? 100;
    });
  }

  Future<void> _saveThreshold() async {
    try {
      var airQuality = await fetchData();
      if (airQuality != null) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('threshold', _threshold);
        setState(() {
          _saveMessage = 'Save successful!';
        });

        // Check if the current AQI surpasses the threshold
        if (airQuality.aqi > _threshold) {
          await NotificationService.showNotification(airQuality.aqi);
        } else {
          print('AQI is below the set threshold, no notification to show.');
        }
      } else {
        throw Exception('Failed to fetch AQI data');
      }
    } catch (e) {
      setState(() {
        _saveMessage = 'Save failed: $e';
      });
    }

    await Future.delayed(Duration(seconds: 2));
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set AQI Threshold'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Set AQI Threshold for Notifications',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Slider(
              value: _threshold.toDouble(),
              min: 0,
              max: 500,
              divisions: 100,
              label: _threshold.toString(),
              onChanged: (double value) {
                setState(() {
                  _threshold = value.toInt();
                });
              },
            ),
            ElevatedButton(
              onPressed: _saveThreshold,
              child: Text('Save Threshold'),
            ),
            if (_saveMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  _saveMessage,
                  style: TextStyle(
                    color: _saveMessage.contains('successful') ? Colors.green : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
