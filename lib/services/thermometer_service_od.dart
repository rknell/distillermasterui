import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';

import '../classes/thermometer.dart';

class ThermometerService extends ChangeNotifier {
  final _dummyData = <Thermometer>[
    Thermometer(uuid: '000001', name: 'Thermometer 1'),
    Thermometer(uuid: '000002', name: 'Thermometer 2'),
    Thermometer(uuid: '000003', name: 'Thermometer 3'),
  ];

  List<Thermometer> get data => _dummyData;

  ThermometerService() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      generateData();
    });
  }

  void generateData() {
    for (var thermometer in _dummyData) {
      if (thermometer.data.isEmpty) {
        var lastTemperature = randomStartingTemperature();

        /// Generate new data for the last 60 * 5 seconds
        /// (5 seconds is the interval between data points)
        /// This is to simulate the last 5 minutes of data
        /// The first data point is the oldest data point.
        ///
        for (var i = 0; i < 60; i++) {
          thermometer.addReading(generateDataPoint(
              lastTemperature: lastTemperature,
              uuid: thermometer.uuid,
              timestamp:
                  DateTime.now().subtract(Duration(seconds: (60 - i) * 5))));
          lastTemperature = thermometer.data.last.temperature;
        }
      }
      thermometer.addReading(generateDataPoint(
          lastTemperature: thermometer.data.last.temperature,
          uuid: thermometer.uuid));
    }
    notifyListeners();
  }

  ThermometerReading generateDataPoint(
      {required double lastTemperature,
      required String uuid,
      DateTime? timestamp}) {
    return ThermometerReading(
        uuid: uuid,
        temperature: randomTemperature(lastTemperature),
        timestamp: timestamp ?? DateTime.now());
  }

  double randomTemperature(double lastTemperature) {
    //generate a random double which is within the range of 1 degree from the lastTemperature
    final random = Random();
    final randomDouble = random.nextDouble();
    final randomTemperature = lastTemperature + (randomDouble - .5);
    return randomTemperature;
  }

  double randomStartingTemperature() {
    // generate and return a random number between 20 and 90 to two decimal places
    final random = Random();
    final randomDouble = random.nextDouble();
    final randomTemperature = 20 + (randomDouble * 70);
    return randomTemperature;
  }
}

ThermometerService get thermometerService {
  if (GetIt.instance.isRegistered<ThermometerService>() == false) {
    GetIt.instance.registerSingleton(ThermometerService());
  }
  return GetIt.instance.get<ThermometerService>();
}
