import 'package:flutter/material.dart';
import '/constants/app_colors.dart';
import '/constants/text_styles.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tips for Improving Air Quality'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.air),
              title: Text('Keep windows and doors closed during high pollution days.'),
            ),
            ListTile(
              leading: Icon(Icons.air),
              title: Text('Use air purifiers with HEPA filters.'),
            ),
            ListTile(
              leading: Icon(Icons.smoke_free),
              title: Text('Avoid smoking indoors.'),
            ),
            ListTile(
              leading: Icon(Icons.open_in_browser),
              title: Text('Ventilate your home by opening windows when outdoor air quality is good.'),
            ),
            ListTile(
              leading: Icon(Icons.kitchen),
              title: Text('Use exhaust fans in the kitchen and bathroom to remove pollutants.'),
            ),
            ListTile(
              leading: Icon(Icons.cleaning_services),
              title: Text('Avoid using harsh chemicals and opt for natural cleaning products.'),
            ),
            ListTile(
              leading: Icon(Icons.local_florist),
              title: Text('Grow indoor plants that can improve air quality, such as spider plants or peace lilies.'),
            ),
            ListTile(
              leading: Icon(Icons.ac_unit),
              title: Text('Regularly clean and maintain HVAC systems.'),
            ),
            ListTile(
              leading: Icon(Icons.emoji_events),
              title: Text('Minimize the use of candles and incense.'),
            ),
            ListTile(
              leading: Icon(Icons.pets),
              title: Text('Keep pets groomed to reduce dander and other allergens.'),
            ),
          ],
        ),
      ),
    );
  }
}
