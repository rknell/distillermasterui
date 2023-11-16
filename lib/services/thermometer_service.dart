import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

import '../classes/thermometer.dart';

class ThermometerService extends ChangeNotifier {
  final List<Thermometer> _thermometers = [];

  List<Thermometer> get data => _thermometers;

  ThermometerService() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      final List<TemperatureReading> readings =
          await OneWireTempService.readTemperatures();
      for (final reading in readings) {
        final thermometer = _thermometers
            .firstWhereOrNull((thermometer) => thermometer.uuid == reading.id);
        if (thermometer == null) {
          _thermometers.add(Thermometer(uuid: reading.id));
          notifyListeners();
        }
        _thermometers
            .firstWhere((thermometer) => thermometer.uuid == reading.id)
            .addReading(ThermometerReading(
                uuid: reading.id, temperature: reading.temp ?? 0));
      }
    });
  }
}

class DummyThermometerService extends ThermometerService {
  final _random = Random();

  @override
  DummyThermometerService() {
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      for (final thermometer in _thermometers) {
        var lastReading =
            ThermometerReading(uuid: thermometer.uuid, temperature: 20.0);
        if (thermometer.data.isNotEmpty) {
          lastReading = thermometer.data.last;
        }
        final newTemperature =
            lastReading.temperature + _random.nextDouble() * 2 - 1;
        thermometer.addReading(ThermometerReading(
            uuid: thermometer.uuid, temperature: newTemperature));
      }
      notifyListeners();
    });
  }

  @override
  final List<Thermometer> _thermometers = [
    Thermometer(uuid: '28.12345678'),
    Thermometer(uuid: '28.3456789'),
    Thermometer(uuid: '28.987654'),
  ];

  @override
  List<Thermometer> get data => _thermometers;
}

ThermometerService get thermometerService {
  if (GetIt.instance.isRegistered<ThermometerService>() == false) {
    if (kDebugMode) {
      GetIt.instance
          .registerSingleton<ThermometerService>(DummyThermometerService());
    } else {
      GetIt.instance.registerSingleton(ThermometerService());
    }
  }
  return GetIt.instance.get<ThermometerService>();
}

class TemperatureReading {
  final String id;
  final double? temp;

  TemperatureReading({required this.id, required this.temp});
}

class OneWireTempService {
  static const String _baseDir = '/sys/bus/w1/devices/';
  static const String _tempFile = 'w1_slave';

  static Future<List<TemperatureReading>> readTemperatures() async {
    final List<TemperatureReading> results = [];

    final Directory baseDir = Directory(_baseDir);
    if (!await baseDir.exists()) {
      throw Exception('1-wire devices directory not found');
    }

    final List<FileSystemEntity> entities = await baseDir.list().toList();
    for (final FileSystemEntity entity in entities) {
      if (entity is Directory) {
        final File tempFile = File('${entity.path}/$_tempFile');
        if (await tempFile.exists()) {
          final String contents = await tempFile.readAsString();
          final String id = entity.path.split('/').last;
          final double? temp = _parseTemperature(contents);
          results.add(TemperatureReading(id: id, temp: temp));
        }
      }
    }

    return results;
  }

  static double? _parseTemperature(String contents) {
    final RegExp regex = RegExp('t=(\\d+)');
    final Match? match = regex.firstMatch(contents);
    if (match != null) {
      final String tempString = match.group(1)!;
      final double temp = double.parse(tempString) / 1000.0;
      return temp;
    } else {
      return null;
    }
  }
}
