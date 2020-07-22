import 'package:json_annotation/json_annotation.dart';
part 'SituationModel.g.dart';

@JsonSerializable()
class SituationModel {
  List<M_situation> m_situation;

  SituationModel(this.m_situation);

  factory SituationModel.fromJson(Map<String, dynamic> json) =>
      _$SituationModelFromJson(json);
}

@JsonSerializable()
class M_situation {
  dynamic id;
  dynamic situation;

  M_situation(this.id, this.situation);

  factory M_situation.fromJson(Map<String, dynamic> json) => _$M_situationFromJson(json);
}