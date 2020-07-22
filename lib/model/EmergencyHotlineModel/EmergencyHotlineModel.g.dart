// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'EmergencyHotlineModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmergencyHotlineModel _$EmergencyHotlineModelFromJson(
    Map<String, dynamic> json) {
  return EmergencyHotlineModel(
    (json['emergency'] as List)
        ?.map((e) =>
            e == null ? null : Emergency.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EmergencyHotlineModelToJson(
        EmergencyHotlineModel instance) =>
    <String, dynamic>{
      'emergency': instance.emergency,
    };

Emergency _$EmergencyFromJson(Map<String, dynamic> json) {
  return Emergency(
    json['id'],
    json['address'],
    json['telephone'],
    json['type'],
  );
}

Map<String, dynamic> _$EmergencyToJson(Emergency instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'address': instance.address,
      'telephone': instance.telephone,
    };
