import 'package:flutter/material.dart';
import '/models/air_quality.dart';

class AirQualityView extends StatelessWidget {
  final AirQuality airQuality;
  const AirQualityView(this.airQuality, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: MediaQuery.of(context).size.height * 0.5, // Adjusted height to fit more content
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white70,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'City: ${airQuality.cityName}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'AQI: ${airQuality.aqi}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                airQuality.message ?? 'No message available',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'CO: ${airQuality.co?.toString() ?? 'Unknown'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'NO2: ${airQuality.no2?.toString() ?? 'Unknown'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'SO2: ${airQuality.so2?.toString() ?? 'Unknown'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'O3: ${airQuality.o3?.toString() ?? 'Unknown'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'PM2.5: ${airQuality.pm25?.toString() ?? 'Unknown'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'PM10: ${airQuality.pm10?.toString() ?? 'Unknown'}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 1.5,
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
