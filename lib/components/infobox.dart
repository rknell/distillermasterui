import 'package:flutter/material.dart';
import '../services/temp_to_abv.dart';

class InfoBox extends StatelessWidget {
  final double temperature;

  InfoBox({required this.temperature});

  double get abv => TempToABV.getVaporABV(temperature);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 100,
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ABV',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(
              height:
                  8), // Add some spacing between the label and the ABV value
          Text(
            abv.toStringAsFixed(2), // Display ABV with 2 decimal places
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
