// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppLinkModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppLinkModel _$AppLinkModelFromJson(Map<String, dynamic> json) {
  return AppLinkModel(
    json['appLink'] == null
        ? null
        : AppLink.fromJson(json['appLink'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AppLinkModelToJson(AppLinkModel instance) =>
    <String, dynamic>{
      'appLink': instance.appLink,
    };

AppLink _$AppLinkFromJson(Map<String, dynamic> json) {
  return AppLink(
    json['id'],
    json['ios'],
    json['android'],
  );
}

Map<String, dynamic> _$AppLinkToJson(AppLink instance) => <String, dynamic>{
      'id': instance.id,
      'ios': instance.ios,
      'android': instance.android,
    };
