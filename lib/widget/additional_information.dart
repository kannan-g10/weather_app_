import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String weatherValue;

  const AdditionalInformation({
    super.key,
    required this.icon,
    required this.label,
    required this.weatherValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 40,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          weatherValue.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        )
      ],
    );
  }
}
