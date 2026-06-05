import 'package:flutter/material.dart';

class FuelSpotTitle extends StatelessWidget {
  const FuelSpotTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        children: [
          TextSpan(text: 'Fuel'),
          TextSpan(text: 'Spot', style: TextStyle(color: Color(0xFFFFCC00))),
        ],
      ),
    );
  }
}
