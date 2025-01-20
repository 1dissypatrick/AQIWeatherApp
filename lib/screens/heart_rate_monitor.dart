import 'dart:async';
import 'package:flutter/material.dart';
import 'package:heart_bpm/heart_bpm.dart';
import '/views/gradient_container.dart';
import '/constants/text_styles.dart';

class HeartRateMonitorScreen extends StatefulWidget {
  const HeartRateMonitorScreen({super.key});
  @override
  _HeartRateMonitorScreenState createState() => _HeartRateMonitorScreenState();
}

class _HeartRateMonitorScreenState extends State<HeartRateMonitorScreen> {
  List<SensorValue> data = [];
  int? bpmValue;
  bool _isMonitoring = false;
  Timer? _timer;

  void _startMonitoring() {
    setState(() {
      _isMonitoring = true;
      bpmValue = null; // Reset BPM value
    });

    _timer = Timer(Duration(seconds: 13), () {
      setState(() {
        _isMonitoring = false;
      });
    });
  }

  String _getHealthMessage() {
    if (bpmValue == null) {
      return "No BPM data available.";
    } else if (bpmValue! < 60) {
      return "Your heart rate is a bit low. Consider resting and monitoring your condition.";
    } else if (bpmValue! > 100) {
      return "Your heart rate is high. It might be best to avoid strenuous outdoor activities.";
    } else {
      return "Your heart rate is within the normal range. Enjoy outdoor activities, but stay mindful of air quality!";
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      children: [
        const Align(
          alignment: Alignment.center,
          child: Text(
            'Heart Rate Monitor',
            style: TextStyles.h1,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.favorite,
              size: 88,
              color: Colors.red,
            ),
            if (_isMonitoring)
              HeartBPMDialog(
                context: context,
                onRawData: (value) {
                  setState(() {
                    if (data.length == 100) {
                      data.removeAt(0);
                    }
                    data.add(value);
                  });
                },
                onBPM: (value) {
                  setState(() {
                    bpmValue = value;
                  });
                },
                child: Text(
                  bpmValue?.toString() ?? "-",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              ElevatedButton(
                onPressed: _startMonitoring,
                child: const Text('Start Monitoring'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        if (!_isMonitoring && bpmValue != null)
          Column(
            children: [
              Text(
                'Heart Rate: $bpmValue bpm',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                _getHealthMessage(),
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ],
          ),
      ],
    );
  }
}
