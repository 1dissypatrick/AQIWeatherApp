import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(int aqi) async {
    String message;

    if (aqi <= 50) {
      message = 'Air quality is good, no pollution risk.';
    } else if (aqi <= 100) {
      message = 'Air quality is acceptable; minor health concern for sensitive people.';
    } else if (aqi <= 150) {
      message = 'Sensitive groups may experience health effects.';
    } else if (aqi <= 200) {
      message = 'Everyone may experience health effects; sensitive groups more serious.';
    } else if (aqi <= 300) {
      message = 'Health warning: entire population at risk.';
    } else {
      message = 'Health alert: serious health effects for everyone.';
    }

    print("Showing notification with AQI: $aqi and message: $message"); // Log message

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Air Quality Alert',
      'Current AQI: $aqi. $message',
      platformChannelSpecifics,
    );
  }
}
