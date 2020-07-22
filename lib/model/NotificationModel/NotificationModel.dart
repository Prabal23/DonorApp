import 'package:json_annotation/json_annotation.dart';

part 'NotificationModel.g.dart';

@JsonSerializable()
class NotificationModel {
  List<Notification> allNotification;

  NotificationModel(this.allNotification);

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}


@JsonSerializable()
class Notification {
 
 dynamic id;
 dynamic fromId;
 dynamic toId;
 dynamic title;
 dynamic msg;
 dynamic seen;

  Notification(this.id, this.msg, this.fromId, this.seen, this.title, this.toId);

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}