// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotificationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    (json['allNotification'] as List)
        ?.map((e) =>
            e == null ? null : Notification.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'allNotification': instance.allNotification,
    };

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    json['id'],
    json['msg'],
    json['fromId'],
    json['seen'],
    json['title'],
    json['toId'],
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fromId': instance.fromId,
      'toId': instance.toId,
      'title': instance.title,
      'msg': instance.msg,
      'seen': instance.seen,
    };
