// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thermometer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thermometer _$ThermometerFromJson(Map<String, dynamic> json) => Thermometer(
      uuid: json['uuid'] as String,
      name: json['name'] as String?,
      type: $enumDecode(_$ThermometerTypeEnumMap, json['type'],
          unknownValue: ThermometerType.Other),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ThermometerReading.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ThermometerToJson(Thermometer instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'name': instance.name,
      'type': _$ThermometerTypeEnumMap[instance.type]!,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

const _$ThermometerTypeEnumMap = {
  ThermometerType.Column: 'Column',
  ThermometerType.Deflegmator: 'Deflegmator',
  ThermometerType.Boiler: 'Boiler',
  ThermometerType.Condensor: 'Condensor',
  ThermometerType.Plate: 'Plate',
  ThermometerType.Other: 'Other',
};

ThermometerReading _$ThermometerReadingFromJson(Map<String, dynamic> json) =>
    ThermometerReading(
      uuid: json['uuid'] as String,
      temperature: (json['temperature'] as num).toDouble(),
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$ThermometerReadingToJson(ThermometerReading instance) =>
    <String, dynamic>{
      'uuid': instance.uuid,
      'temperature': instance.temperature,
      'timestamp': instance.timestamp.toIso8601String(),
    };
