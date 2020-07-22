import 'package:json_annotation/json_annotation.dart';

part 'IncidentListModel.g.dart';
@JsonSerializable()
class IncidentListModel {
  List<Incident> incident;

  IncidentListModel(this.incident);

  factory IncidentListModel.fromJson(Map<String, dynamic> json) =>
      _$IncidentListModelFromJson(json);

  Map<String, dynamic> toJson() => _$IncidentListModelToJson(this);
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
  dynamic address;
  dynamic created_at;
  List<Photo> photo;
  List<MoneyDonation> money_donation;
  List<Donation> donation;
  Beneficiar beneficiar;

  Incident(this.id, this.money_donation, this.beneficiarId, this.address, this.donation, this.situation, this.messageForDoner, this.photo, this.status, this.lat, this.lng, this.created_at, this.beneficiar);

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

@JsonSerializable()
class Photo {
  dynamic id;
  dynamic incidentId;
  dynamic imgUrl;

  Photo(this.id, this.incidentId, this.imgUrl);

  factory Photo.fromJson(Map<String, dynamic> json) =>
      _$PhotoFromJson(json);
  Map<String, dynamic> toJson() => _$PhotoToJson(this);
}

@JsonSerializable()
class MoneyDonation {
  dynamic id;
  dynamic incidentId;
  dynamic donerId;
  dynamic payment_img;
  dynamic created_at;

  MoneyDonation(this.id, this.incidentId, this.donerId, this.created_at, this.payment_img);

  factory MoneyDonation.fromJson(Map<String, dynamic> json) =>
      _$MoneyDonationFromJson(json);
  Map<String, dynamic> toJson() => _$MoneyDonationToJson(this);
}

@JsonSerializable()
class Donation {
  dynamic id;
  dynamic pickupDate;
  dynamic pickupTime;
  dynamic incidentId;
  dynamic riderId;
  dynamic donerId;
  dynamic lat;
  dynamic lng;
  dynamic shareMessage;
  dynamic status;
  dynamic isCancel;
  dynamic created_at;
  Rider rider;

  Donation(this.id, this.pickupDate, this.rider, this.pickupTime, this.created_at, this.incidentId, this.donerId, this.isCancel, this.lat, this.lng, this.riderId, this.shareMessage, this.status);

  factory Donation.fromJson(Map<String, dynamic> json) =>
      _$DonationFromJson(json);
  Map<String, dynamic> toJson() => _$DonationToJson(this);
}

@JsonSerializable()
class Beneficiar {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic email_verified_at;
  dynamic userType;
  dynamic mobileNumber;
  dynamic paymaya;
  dynamic gcash;
  dynamic image;
  dynamic lat;
  dynamic lng;
  dynamic created_at;

  Beneficiar(this.id, this.gcash, this.paymaya, this.name, this.email, this.email_verified_at, this.userType,
      this.mobileNumber, this.image, this.lat, this.lng, this.created_at);

  factory Beneficiar.fromJson(Map<String, dynamic> json) =>
      _$BeneficiarFromJson(json);
  Map<String, dynamic> toJson() => _$BeneficiarToJson(this);
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


