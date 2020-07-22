// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ThanksModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThanksModel _$ThanksModelFromJson(Map<String, dynamic> json) {
  return ThanksModel(
    (json['showThank'] as List)
        ?.map((e) =>
            e == null ? null : ShowThank.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ThanksModelToJson(ThanksModel instance) =>
    <String, dynamic>{
      'showThank': instance.showThank,
    };

ShowThank _$ShowThankFromJson(Map<String, dynamic> json) {
  return ShowThank(
    json['id'],
    json['beneficiar'] == null
        ? null
        : Beneficiar.fromJson(json['beneficiar'] as Map<String, dynamic>),
    json['created_at'],
    json['donation'] == null
        ? null
        : Donation.fromJson(json['donation'] as Map<String, dynamic>),
    json['donationId'],
    json['doner'] == null
        ? null
        : Doner.fromJson(json['doner'] as Map<String, dynamic>),
    json['from_beneficier_id'],
    json['message'],
    json['to_doner_id'],
  );
}

Map<String, dynamic> _$ShowThankToJson(ShowThank instance) => <String, dynamic>{
      'id': instance.id,
      'donationId': instance.donationId,
      'from_beneficier_id': instance.from_beneficier_id,
      'to_doner_id': instance.to_doner_id,
      'message': instance.message,
      'created_at': instance.created_at,
      'beneficiar': instance.beneficiar,
      'doner': instance.doner,
      'donation': instance.donation,
    };

Beneficiar _$BeneficiarFromJson(Map<String, dynamic> json) {
  return Beneficiar(
    json['id'],
    json['name'],
    json['email'],
    json['image'],
    json['lat'],
    json['lng'],
    json['mobileNumber'],
  );
}

Map<String, dynamic> _$BeneficiarToJson(Beneficiar instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
      'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
    };

Donation _$DonationFromJson(Map<String, dynamic> json) {
  return Donation(
    json['id'],
    json['pickupDate'],
    json['address'],
    json['created_at'],
    json['donerId'],
    json['image'],
    json['incidentId'],
    json['isCancel'],
    json['pickupTime'],
    json['reason'],
    json['shareMessage'],
    json['status'],
    json['updated_at'],
    json['lat'],
    json['lng'],
  );
}

Map<String, dynamic> _$DonationToJson(Donation instance) => <String, dynamic>{
      'id': instance.id,
      'pickupDate': instance.pickupDate,
      'pickupTime': instance.pickupTime,
      'incidentId': instance.incidentId,
      'donerId': instance.donerId,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'shareMessage': instance.shareMessage,
      'status': instance.status,
      'isCancel': instance.isCancel,
      'reason': instance.reason,
      'image': instance.image,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

Doner _$DonerFromJson(Map<String, dynamic> json) {
  return Doner(
    json['id'],
    json['name'],
    json['email'],
    json['image'],
    json['lat'],
    json['lng'],
    json['mobileNumber'],
  );
}

Map<String, dynamic> _$DonerToJson(Doner instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
      'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
    };
