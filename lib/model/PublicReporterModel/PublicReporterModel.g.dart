// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PublicReporterModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PublicReporterModel _$PublicReporterModelFromJson(Map<String, dynamic> json) {
  return PublicReporterModel(
    (json['publicReport'] as List)
        ?.map((e) =>
            e == null ? null : PublicReport.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PublicReporterModelToJson(
        PublicReporterModel instance) =>
    <String, dynamic>{
      'publicReport': instance.publicReport,
    };

PublicReport _$PublicReportFromJson(Map<String, dynamic> json) {
  return PublicReport(
    json['id'],
    json['address'],
    json['created_at'],
    json['lat'],
    json['lng'],
    json['messageForAuthorities'],
    (json['photo'] as List)
        ?.map(
            (e) => e == null ? null : Photo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['reporterId'],
    json['situation'] == null
        ? null
        : Situation.fromJson(json['situation'] as Map<String, dynamic>),
    json['situationId'],
    (json['video'] as List)
        ?.map(
            (e) => e == null ? null : Video.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PublicReportToJson(PublicReport instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporterId': instance.reporterId,
      'situationId': instance.situationId,
      'messageForAuthorities': instance.messageForAuthorities,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'created_at': instance.created_at,
      'situation': instance.situation,
      'photo': instance.photo,
      'video': instance.video,
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

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    json['id'],
    json['publicReportId'],
    json['imgUrl'],
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'publicReportId': instance.publicReportId,
      'imgUrl': instance.imgUrl,
    };

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video(
    json['id'],
    json['publicReportId'],
    json['videoUrl'],
  );
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'publicReportId': instance.publicReportId,
      'videoUrl': instance.videoUrl,
    };
