import 'package:json_annotation/json_annotation.dart';

part 'DonationsForRiderModel.g.dart';
@JsonSerializable()
class DonationsForRiderModel {
  List<DonationforRider> donationforRider;

  DonationsForRiderModel(this.donationforRider);

  factory DonationsForRiderModel.fromJson(Map<String, dynamic> json) =>
      _$DonationsForRiderModelFromJson(json);

  Map<String, dynamic> toJson() => _$DonationsForRiderModelToJson(this);
}


@JsonSerializable()
class DonationforRider {
  dynamic id;
  dynamic pickupDate;
  dynamic pickupTime;
  dynamic incidentId;
  dynamic riderId;
  dynamic donerId;
  dynamic lat;
  dynamic lng;
  dynamic address;
  dynamic shareMessage;
  dynamic status;
  dynamic isCancel;
  dynamic updated_at;
  Incident incident;
  List<Photo> photo;
  Rider rider;
  Doner doner;

  DonationforRider(this.id, this.updated_at, this.address, this.pickupDate, this.rider, this.doner, this.donerId, this.incident, this.incidentId, this.isCancel, this.lat, this.lng, this.photo, this.pickupTime, this.riderId, this.shareMessage, this.status);

  factory DonationforRider.fromJson(Map<String, dynamic> json) =>
      _$DonationforRiderFromJson(json);
  Map<String, dynamic> toJson() => _$DonationforRiderToJson(this);
}

@JsonSerializable()
class Incident {
  dynamic id;
  dynamic beneficiarId;
  dynamic situation;
  dynamic messageForDoner;
  dynamic status;
  dynamic lat;
  dynamic lng;

  Incident(this.id, this.beneficiarId, this.lat, this.lng, this.messageForDoner, this.situation, this.status);

  factory Incident.fromJson(Map<String, dynamic> json) =>
      _$IncidentFromJson(json);
  Map<String, dynamic> toJson() => _$IncidentToJson(this);
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

@JsonSerializable()
class Rider {
  dynamic id;
  dynamic name;
  dynamic lat;
  dynamic lng;

  Rider(this.id, this.name, this.lat, this.lng);

  factory Rider.fromJson(Map<String, dynamic> json) =>
      _$RiderFromJson(json);
  Map<String, dynamic> toJson() => _$RiderToJson(this);
}

@JsonSerializable()
class Doner {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic mobileNumber;
  dynamic device_id;
  dynamic image;
  dynamic lat;
  dynamic lng;

  Doner(this.id, this.name, this.device_id, this.email, this.image, this.lat, this.lng, this.mobileNumber);

  factory Doner.fromJson(Map<String, dynamic> json) =>
      _$DonerFromJson(json);
  Map<String, dynamic> toJson() => _$DonerToJson(this);
}