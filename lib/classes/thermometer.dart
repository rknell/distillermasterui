import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'thermometer.g.dart';

@JsonSerializable(explicitToJson: true)
class Thermometer extends ChangeNotifier {
  String uuid;
  String? name;

  List<ThermometerReading> data;

  void addReading(ThermometerReading reading) {
    if (data.length > 60) {
      data.removeAt(0);
    }
    data.add(reading);
    notifyListeners();
  }

  Thermometer({required this.uuid, this.name, List<ThermometerReading>? data})
      : data = data ?? <ThermometerReading>[];

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
