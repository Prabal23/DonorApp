// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DonorModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonorModel _$DonorModelFromJson(Map<String, dynamic> json) {
  return DonorModel(
    (json['donations'] as List)
        ?.map((e) =>
            e == null ? null : Donations.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DonorModelToJson(DonorModel instance) =>
    <String, dynamic>{
      'donations': instance.donations,
    };

Donations _$DonationsFromJson(Map<String, dynamic> json) {
  return Donations(
    json['id'],
    json['pickupDate'],
    (json['photo'] as List)
        ?.map(
            (e) => e == null ? null : Photo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['incidentId'],
    json['donerId'],
    json['pickupTime'],
    json['status'],
    json['lat'],
    json['lng'],
    json['shareMessage'],
    json['isCancel'],
    json['rider'] == null
        ? null
        : Rider.fromJson(json['rider'] as Map<String, dynamic>),
    json['doner'] == null
        ? null
        : Doner.fromJson(json['doner'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DonationsToJson(Donations instance) => <String, dynamic>{
      'id': instance.id,
      'pickupDate': instance.pickupDate,
      'pickupTime': instance.pickupTime,
      'incidentId': instance.incidentId,
      'donerId': instance.donerId,
      'status': instance.status,
      'lat': instance.lat,
      'lng': instance.lng,
      'shareMessage': instance.shareMessage,
      'isCancel': instance.isCancel,
      'rider': instance.rider,
      'doner': instance.doner,
      'photo': instance.photo,
    };

Rider _$RiderFromJson(Map<String, dynamic> json) {
  return Rider(
    json['id'],
    json['name'],
    json['email'],
    json['userType'],
    json['mobileNumber'],
    json['image'],
    json['lat'],
    json['lng'],
  );
}

Map<String, dynamic> _$RiderToJson(Rider instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'userType': instance.userType,
      'mobileNumber': instance.mobileNumber,
      'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
    };

Doner _$DonerFromJson(Map<String, dynamic> json) {
  return Doner(
    json['id'],
    json['name'],
    json['email'],
    json['userType'],
    json['mobileNumber'],
    json['image'],
    json['lat'],
    json['lng'],
  );
}

Map<String, dynamic> _$DonerToJson(Doner instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'userType': instance.userType,
      'mobileNumber': instance.mobileNumber,
      'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
    };

Photo _$PhotoFromJson(Map<String, dynamic> json) {
  return Photo(
    json['id'],
    json['donationId'],
    json['imgUrl'],
  );
}

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
      'id': instance.id,
      'donationId': instance.donationId,
      'imgUrl': instance.imgUrl,
    };
