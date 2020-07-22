// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IncidentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentModel _$IncidentModelFromJson(Map<String, dynamic> json) {
  return IncidentModel(
    json['incident'] == null
        ? null
        : Incident.fromJson(json['incident'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$IncidentModelToJson(IncidentModel instance) =>
    <String, dynamic>{
      'incident': instance.incident,
    };

Incident _$IncidentFromJson(Map<String, dynamic> json) {
  return Incident(
    json['id'],
    json['beneficiarId'],
    json['situation'] == null
        ? null
        : Situation.fromJson(json['situation'] as Map<String, dynamic>),
    json['messageForDoner'],
    json['status'],
    json['lat'],
    json['lng'],
    json['created_at'],
  );
}

Map<String, dynamic> _$IncidentToJson(Incident instance) => <String, dynamic>{
      'id': instance.id,
      'beneficiarId': instance.beneficiarId,
      'situation': instance.situation,
      'messageForDoner': instance.messageForDoner,
      'status': instance.status,
      'lat': instance.lat,
      'lng': instance.lng,
      'created_at': instance.created_at,
    };

Situation _$SituationFromJson(Map<String, dynamic> json) {
  return Situation(
    json['id'],
    json['situation'],
  );
}

Map<String, dynamic> _$SituationToJson(Situation instance) => <String, dynamic>{
      'id': instance.id,
      'situation': instance.situation,
    };
