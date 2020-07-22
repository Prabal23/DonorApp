import 'package:json_annotation/json_annotation.dart';
part 'AppLinkModel.g.dart';

@JsonSerializable()
class AppLinkModel {
  AppLink appLink;

  AppLinkModel(this.appLink);

  factory AppLinkModel.fromJson(Map<String, dynamic> json) =>
      _$AppLinkModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppLinkModelToJson(this);
}

@JsonSerializable()
class AppLink {
  dynamic id;
  dynamic ios;
  dynamic android;

  AppLink(this.id, this.ios, this.android);

  factory AppLink.fromJson(Map<String, dynamic> json) =>
      _$AppLinkFromJson(json);
  Map<String, dynamic> toJson() => _$AppLinkToJson(this);
}