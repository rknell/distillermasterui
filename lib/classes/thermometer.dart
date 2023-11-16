import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thermometer.g.dart';

@JsonSerializable(explicitToJson: true)
class Thermometer extends ChangeNotifier {
  String uuid;
  String? name;
  @JsonKey(unknownEnumValue: ThermometerType.Other)
  ThermometerType type;

  List<ThermometerReading> data;

  final File _file = File('thermometer_settings.json');

  Thermometer(
      {required this.uuid,
      this.name,
      ThermometerType? type,
      List<ThermometerReading>? data})
      : data = data ?? <ThermometerReading>[],
        type = type ?? ThermometerType.Other {
    if (name != null) {
      save();
    }
    if (name == null) {
      if (_file.existsSync()) {
        final contents = _file.readAsStringSync();
        final nameMapping = json.decode(contents);
        if (nameMapping.containsKey(uuid)) {
          final mapping = nameMapping[uuid];
          name = mapping['name'];
          type = ThermometerType.values[mapping['type']];
        }
      }
    }
  }

  void addReading(ThermometerReading reading) {
    if (data.length > 60) {
      data.removeAt(0);
    }
    data.add(reading);
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    save();
  }

  void setType(ThermometerType type) {
    this.type = type;
    save();
  }

  void save() async {
    Map<String, dynamic> nameMapping = {};
    if (await _file.exists()) {
      final contents = await _file.readAsString();
      nameMapping = json.decode(contents);
    }
    nameMapping[uuid] = {'name': name, 'type': type.index};
    await _file.writeAsString(json.encode(nameMapping));
  }

  factory Thermometer.fromJson(Map<String, dynamic> json) =>
      _$ThermometerFromJson(json);

  Map<String, dynamic> toJson() => _$ThermometerToJson(this);

  Thermometer fromJson(Map<String, dynamic> json) => Thermometer.fromJson(json);
}

@JsonSerializable(explicitToJson: true)
class ThermometerReading {
  String uuid;
  double temperature;
  DateTime timestamp;

  ThermometerReading(
      {required this.uuid, required this.temperature, DateTime? timestamp})
      : timestamp = timestamp ?? DateTime.now();

  factory ThermometerReading.fromJson(Map<String, dynamic> json) =>
      _$ThermometerReadingFromJson(json);

  Map<String, dynamic> toJson() => _$ThermometerReadingToJson(this);

  ThermometerReading fromJson(Map<String, dynamic> json) =>
      ThermometerReading.fromJson(json);
}

enum ThermometerType { Column, Deflegmator, Boiler, Condensor, Plate, Other }
