import 'package:json_annotation/json_annotation.dart';

part 'DirectionList.g.dart';

@JsonSerializable()
class DirectionList {
  List<Routes> routes;
  dynamic status;

  DirectionList(this.routes, this.status);

  factory DirectionList.fromJson(Map<String, dynamic> json) =>
      _$DirectionListFromJson(json);

  Map<String, dynamic> toJson() => _$DirectionListToJson(this);
}

@JsonSerializable()
class Routes {
  dynamic copyrights;
  List<Legs> legs; 
  Overview_polyline overview_polyline;

  Routes(this.copyrights, this.overview_polyline);

  factory Routes.fromJson(Map<String, dynamic> json) =>
      _$RoutesFromJson(json);

  Map<String, dynamic> toJson() => _$RoutesToJson(this);
}


@JsonSerializable()
class Legs {

  Distance distance;
  DurationTime duration;
  dynamic end_address;
  dynamic start_address;

  Legs(this.distance, this.duration, this.end_address, this.start_address);

  factory Legs.fromJson(Map<String, dynamic> json) => _$LegsFromJson(json);
}

@JsonSerializable()
class Overview_polyline {
  dynamic points;

  Overview_polyline(this.points);

    factory Overview_polyline.fromJson(Map<String, dynamic> json) =>
      _$Overview_polylineFromJson(json);

  Map<String, dynamic> toJson() => _$Overview_polylineToJson(this);
}


@JsonSerializable()
class Distance {
  dynamic text;

  Distance(this.text);

  factory Distance.fromJson(Map<String, dynamic> json) =>
      _$DistanceFromJson(json);

  Map<String, dynamic> toJson() => _$DistanceToJson(this);
}

@JsonSerializable()
class DurationTime {
  dynamic text;

  DurationTime(this.text);

  factory DurationTime.fromJson(Map<String, dynamic> json) =>
      _$DurationTimeFromJson(json);

  Map<String, dynamic> toJson() => _$DurationTimeToJson(this);
}