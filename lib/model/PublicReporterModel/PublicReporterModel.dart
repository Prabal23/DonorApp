import 'package:json_annotation/json_annotation.dart';

part 'PublicReporterModel.g.dart';
@JsonSerializable()
class PublicReporterModel {
  List<PublicReport> publicReport;

  PublicReporterModel(this.publicReport);

  factory PublicReporterModel.fromJson(Map<String, dynamic> json) =>
      _$PublicReporterModelFromJson(json);

  Map<String, dynamic> toJson() => _$PublicReporterModelToJson(this);
}

@JsonSerializable()
class PublicReport {
  dynamic id;
  dynamic reporterId;
  dynamic situationId;
  dynamic messageForAuthorities;
  dynamic lat;
  dynamic lng;
  dynamic address;
  dynamic created_at;
  Situation situation;
  List<Photo> photo;
  List<Video> video;

  PublicReport(this.id, this.address, this.created_at, this.lat, this.lng, this.messageForAuthorities, this.photo, this.reporterId, this.situation, this.situationId, this.video);

  factory PublicReport.fromJson(Map<String, dynamic> json) =>
      _$PublicReportFromJson(json);
  Map<String, dynamic> toJson() => _$PublicReportToJson(this);
}

@JsonSerializable()
class Situation {
  dynamic id;
  dynamic situation;

  Situation(this.id, this.situation);

  factory Situation.fromJson(Map<String, dynamic> json) =>
      _$SituationFromJson(json);
  Map<String, dynamic> toJson() => _$SituationToJson(this);
}

@JsonSerializable()
class Photo {
  dynamic id;
  dynamic publicReportId;
  dynamic imgUrl;

  Photo(this.id, this.publicReportId, this.imgUrl);

  factory Photo.fromJson(Map<String, dynamic> json) =>
      _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

@JsonSerializable()
class Video {
  dynamic id;
  dynamic publicReportId;
  dynamic videoUrl;

  Video(this.id, this.publicReportId, this.videoUrl);

  factory Video.fromJson(Map<String, dynamic> json) =>
      _$VideoFromJson(json);
  Map<String, dynamic> toJson() => _$VideoToJson(this);
}