import 'package:json_annotation/json_annotation.dart';

part 'ThanksModel.g.dart';
@JsonSerializable()
class ThanksModel {
  List<ShowThank> showThank;

  ThanksModel(this.showThank);

  factory ThanksModel.fromJson(Map<String, dynamic> json) =>
      _$ThanksModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThanksModelToJson(this);
}


@JsonSerializable()
class ShowThank {
  dynamic id;
  dynamic donationId;
  dynamic from_beneficier_id;
  dynamic to_doner_id;
  dynamic message;
  dynamic created_at;
  Beneficiar beneficiar;
  Doner doner;
  Donation donation;

  ShowThank(this.id, this.beneficiar, this.created_at, this.donation, this.donationId, this.doner, this.from_beneficier_id, this.message, this.to_doner_id);

  factory ShowThank.fromJson(Map<String, dynamic> json) =>
      _$ShowThankFromJson(json);
  Map<String, dynamic> toJson() => _$ShowThankToJson(this);
}

@JsonSerializable()
class Beneficiar {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic mobileNumber;
  dynamic image;
  dynamic lat;
  dynamic lng;

  Beneficiar(this.id, this.name, this.email, this.image, this.lat, this.lng, this.mobileNumber);

  factory Beneficiar.fromJson(Map<String, dynamic> json) =>
      _$BeneficiarFromJson(json);
  Map<String, dynamic> toJson() => _$BeneficiarToJson(this);
}

@JsonSerializable()
class Donation {
  dynamic id;
  dynamic pickupDate;
  dynamic pickupTime;
  dynamic incidentId;
  dynamic donerId;
  dynamic lat;
  dynamic lng;
  dynamic address;
  dynamic shareMessage;
  dynamic status;
  dynamic isCancel;
  dynamic reason;
  dynamic image;
  dynamic created_at;
  dynamic updated_at;

  Donation(this.id, this.pickupDate, this.address, this.created_at, this.donerId, this.image, this.incidentId, this.isCancel, this.pickupTime, this.reason, this.shareMessage, this.status, this.updated_at, this.lat, this.lng);

  factory Donation.fromJson(Map<String, dynamic> json) =>
      _$DonationFromJson(json);
  Map<String, dynamic> toJson() => _$DonationToJson(this);
}

@JsonSerializable()
class Doner {
  dynamic id;
  dynamic name;
  dynamic email;
  dynamic mobileNumber;
  dynamic image;
  dynamic lat;
  dynamic lng;

  Doner(this.id, this.name, this.email, this.image, this.lat, this.lng, this.mobileNumber);

  factory Doner.fromJson(Map<String, dynamic> json) =>
      _$DonerFromJson(json);
  Map<String, dynamic> toJson() => _$DonerToJson(this);
}