import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
  final IconData weatherIcon;
  final String time;
  final String weather;

  const HourlyForecast({
    super.key,
    required this.weatherIcon,
    required this.time,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        width: 105,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Icon(
              weatherIcon,
              size: 32,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(weather),
          ],
        ),
      ),
    );
  }
}
