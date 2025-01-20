import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '/constants/app_colors.dart';
import '/constants/text_styles.dart';
import '/extensions/datetime.dart';
import '/extensions/strings.dart';
import '/providers/get_current_weather_provider.dart';
import '/views/gradient_container.dart';
import '/views/hourly_forecast_view.dart';
import '/views/weekly_forecast_view.dart';
import 'weather_info.dart';

// StateNotifier to manage the visibility of the Next Forecast section
class NextForecastNotifier extends StateNotifier<bool> {
  NextForecastNotifier() : super(false);

  void toggle() => state = !state;
}

final nextForecastProvider =
StateNotifierProvider<NextForecastNotifier, bool>((ref) {
  return NextForecastNotifier();
});

class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weatherData = ref.watch(currentWeatherProvider);
    final showNextForecast = ref.watch(nextForecastProvider);

    return weatherData.when(
      data: (weather) {
        return GradientContainer(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  width: double.infinity,
                ),
                // Country name text
                Text(
                  weather.name,
                  style: TextStyles.h1,
                ),

                const SizedBox(height: 20),

                // Today's date
                Text(
                  DateTime.now().dateTime,
                  style: TextStyles.subtitleText,
                ),

                const SizedBox(height: 20),

                // Weather icon big
                SizedBox(
                  height: 200,
                  child: Image.asset(
                    'assets/icons/${weather.weather[0].icon.replaceAll('n', 'd')}.png',
                    fit: BoxFit.contain,
                  ),
                ),

                const SizedBox(height: 20),

                // Weather description
                Text(
                  weather.weather[0].description.capitalize,
                  style: TextStyles.h2,
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Weather info in a row
            WeatherInfo(weather: weather),

            const SizedBox(height: 20),

            // Today Daily Forecast
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppColors.white,
                  ),
                ),
                InkWell(
                  child: Text(
                    'Three hours apart',
                    style: TextStyle(
                      color: AppColors.lightBlue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // hourly forcast
            const HourlyForecastView(),
            const SizedBox(height: 20),

            // Next Forecast
            InkWell(
              onTap: () => ref.read(nextForecastProvider.notifier).toggle(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Next Forecast (Within a week)',
                    style: TextStyles.h2,
                  ),
                  Icon(
                    showNextForecast
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Weekly forecast
            if (showNextForecast) const WeeklyForecastView(),
          ],
        );
      },
      error: (error, stackTrace) {
        return const Center(
          child: Text(
            'An error has occurred',
          ),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
