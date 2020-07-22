import 'package:json_annotation/json_annotation.dart';
part 'DonorModel.g.dart';

@JsonSerializable()
class DonorModel {
  List<Donations> donations;

  DonorModel(this.donations);

  factory DonorModel.fromJson(Map<String, dynamic> json) =>
      _$DonorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DonorModelToJson(this);
}

@JsonSerializable()
class Donations {
  dynamic id;
  dynamic pickupDate;
  dynamic pickupTime;
  dynamic incidentId;
  dynamic donerId;
  dynamic status;
  dynamic lat;
  dynamic lng;
  dynamic shareMessage;
  dynamic isCancel;
  Rider rider;
  Doner doner;
  List<Photo> photo;

  Donations(this.id, this.pickupDate, this.photo, this.incidentId, this.donerId, this.pickupTime, this.status, this.lat,
      this.lng, this.shareMessage, this.isCancel, this.rider, this.doner);

  factory Donations.fromJson(Map<String, dynamic> json) =>
      _$DonationsFromJson(json);
  Map<String, dynamic> toJson() => _$DonationsToJson(this);
}

@JsonSerializable()
class Rider {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic userType;
  dynamic mobileNumber;
  dynamic image;
  dynamic lat;
  dynamic lng;

  Rider(this.id, this.name, this.email, this.userType, this.mobileNumber,
      this.image, this.lat, this.lng);

  factory Rider.fromJson(Map<String, dynamic> json) =>
      _$RiderFromJson(json);
  Map<String, dynamic> toJson() => _$RiderToJson(this);
}

@JsonSerializable()
class Doner {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic userType;
  dynamic mobileNumber;
  dynamic image;
  dynamic lat;
  dynamic lng;

  Doner(this.id, this.name, this.email, this.userType, this.mobileNumber,
      this.image, this.lat, this.lng);

  factory Doner.fromJson(Map<String, dynamic> json) =>
      _$DonerFromJson(json);
  Map<String, dynamic> toJson() => _$DonerToJson(this);
}

@JsonSerializable()
class Photo {
  dynamic id;
  dynamic donationId;
  dynamic imgUrl;

  Photo(this.id, this.donationId, this.imgUrl);

  factory Photo.fromJson(Map<String, dynamic> json) =>
      _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}
