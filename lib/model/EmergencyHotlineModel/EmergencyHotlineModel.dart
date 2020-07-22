import 'package:json_annotation/json_annotation.dart';

part 'EmergencyHotlineModel.g.dart';
@JsonSerializable()
class EmergencyHotlineModel {
  List<Emergency> emergency;

  EmergencyHotlineModel(this.emergency);

  factory EmergencyHotlineModel.fromJson(Map<String, dynamic> json) =>
      _$EmergencyHotlineModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmergencyHotlineModelToJson(this);
}

@JsonSerializable()
class Emergency {
  dynamic id;
  dynamic type;
  dynamic address;
  dynamic telephone;

  Emergency(this.id, this.address, this.telephone, this.type);

  factory Emergency.fromJson(Map<String, dynamic> json) =>
      _$EmergencyFromJson(json);
  Map<String, dynamic> toJson() => _$EmergencyToJson(this);
}