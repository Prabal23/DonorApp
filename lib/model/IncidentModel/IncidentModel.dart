import 'package:json_annotation/json_annotation.dart';
part 'IncidentModel.g.dart';

@JsonSerializable()
class IncidentModel {
  Incident incident;

  IncidentModel(this.incident);

  factory IncidentModel.fromJson(Map<String, dynamic> json) =>
      _$IncidentModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentModelToJson(this);
}

@JsonSerializable()
class Incident {
  dynamic id;
  dynamic beneficiarId;
  Situation situation;
  dynamic messageForDoner;
  dynamic status;
  dynamic lat;
  dynamic lng;
  dynamic created_at;

  Incident(this.id, this.beneficiarId, this.situation, this.messageForDoner,
      this.status, this.lat, this.lng, this.created_at);

  factory Incident.fromJson(Map<String, dynamic> json) =>
      _$IncidentFromJson(json);
  Map<String, dynamic> toJson() => _$IncidentToJson(this);
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
