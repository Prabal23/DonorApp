// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IncidentListModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncidentListModel _$IncidentListModelFromJson(Map<String, dynamic> json) {
  return IncidentListModel(
    (json['incident'] as List)
        ?.map((e) =>
            e == null ? null : Incident.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$IncidentListModelToJson(IncidentListModel instance) =>
    <String, dynamic>{
      'incident': instance.incident,
    };

Incident _$IncidentFromJson(Map<String, dynamic> json) {
  return Incident(
    json['id'],
    (json['money_donation'] as List)
        ?.map((e) => e == null
            ? null
            : MoneyDonation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['beneficiarId'],
    json['address'],
    (json['donation'] as List)
        ?.map((e) =>
            e == null ? null : Donation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['situation'] == null
        ? null
        : Situation.fromJson(json['situation'] as Map<String, dynamic>),
    json['messageForDoner'],
    (json['photo'] as List)
        ?.map(
            (e) => e == null ? null : Photo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['status'],
    json['lat'],
    json['lng'],
    json['created_at'],
    json['beneficiar'] == null
        ? null
        : Beneficiar.fromJson(json['beneficiar'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$IncidentToJson(Incident instance) => <String, dynamic>{
      'id': instance.id,
      'beneficiarId': instance.beneficiarId,
      'situation': instance.situation,
      'messageForDoner': instance.messageForDoner,
      'status': instance.status,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'created_at': instance.created_at,
      'photo': instance.photo,
      'money_donation': instance.money_donation,
      'donation': instance.donation,
      'beneficiar': instance.beneficiar,
    };

Situation _$SituationFromJson(Map<String, dynamic> json) {
  return Situation(
    json['id'],
    json['situation'],
  );
}

Map<String, dynamic> _$SituationToJson(Situation instance) => <String, dynamic>{
      'id': instance.id,
      'situation': instance.situation,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    json['id'],
    json['incidentId'],
    json['imgUrl'],
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'incidentId': instance.incidentId,
      'imgUrl': instance.imgUrl,
    };

MoneyDonation _$MoneyDonationFromJson(Map<String, dynamic> json) {
  return MoneyDonation(
    json['id'],
    json['incidentId'],
    json['donerId'],
    json['created_at'],
    json['payment_img'],
  );
}

Map<String, dynamic> _$MoneyDonationToJson(MoneyDonation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'incidentId': instance.incidentId,
      'donerId': instance.donerId,
      'payment_img': instance.payment_img,
      'created_at': instance.created_at,
    };

Donation _$DonationFromJson(Map<String, dynamic> json) {
  return Donation(
    json['id'],
    json['pickupDate'],
    json['rider'] == null
        ? null
        : Rider.fromJson(json['rider'] as Map<String, dynamic>),
    json['pickupTime'],
    json['created_at'],
    json['incidentId'],
    json['donerId'],
    json['isCancel'],
    json['lat'],
    json['lng'],
    json['riderId'],
    json['shareMessage'],
    json['status'],
  );
}

Map<String, dynamic> _$DonationToJson(Donation instance) => <String, dynamic>{
      'id': instance.id,
      'pickupDate': instance.pickupDate,
      'pickupTime': instance.pickupTime,
      'incidentId': instance.incidentId,
      'riderId': instance.riderId,
      'donerId': instance.donerId,
      'lat': instance.lat,
      'lng': instance.lng,
      'shareMessage': instance.shareMessage,
      'status': instance.status,
      'isCancel': instance.isCancel,
      'created_at': instance.created_at,
      'rider': instance.rider,
    };

Beneficiar _$BeneficiarFromJson(Map<String, dynamic> json) {
  return Beneficiar(
    json['id'],
    json['gcash'],
    json['paymaya'],
    json['name'],
    json['email'],
    json['email_verified_at'],
    json['userType'],
    json['mobileNumber'],
    json['image'],
    json['lat'],
    json['lng'],
    json['created_at'],
  );
}

Map<String, dynamic> _$BeneficiarToJson(Beneficiar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'email_verified_at': instance.email_verified_at,
      'userType': instance.userType,
      'mobileNumber': instance.mobileNumber,
      'paymaya': instance.paymaya,
      'gcash': instance.gcash,
      'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
      'created_at': instance.created_at,
    };

Rider _$RiderFromJson(Map<String, dynamic> json) {
  return Rider(
    json['id'],
    json['name'],
    json['lat'],
    json['lng'],
  );
}

Map<String, dynamic> _$RiderToJson(Rider instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'lat': instance.lat,
      'lng': instance.lng,
    };
