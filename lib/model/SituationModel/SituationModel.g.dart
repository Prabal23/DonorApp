// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SituationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SituationModel _$SituationModelFromJson(Map<String, dynamic> json) {
  return SituationModel(
    (json['m_situation'] as List)
        ?.map((e) =>
            e == null ? null : M_situation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$SituationModelToJson(SituationModel instance) =>
    <String, dynamic>{
      'm_situation': instance.m_situation,
    };

M_situation _$M_situationFromJson(Map<String, dynamic> json) {
  return M_situation(
    json['id'],
    json['situation'],
  );
}

Map<String, dynamic> _$M_situationToJson(M_situation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'situation': instance.situation,
    };
