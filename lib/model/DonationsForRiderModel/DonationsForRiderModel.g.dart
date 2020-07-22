// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DonationsForRiderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DonationsForRiderModel _$DonationsForRiderModelFromJson(
    Map<String, dynamic> json) {
  return DonationsForRiderModel(
    (json['donationforRider'] as List)
        ?.map((e) => e == null
            ? null
            : DonationforRider.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DonationsForRiderModelToJson(
        DonationsForRiderModel instance) =>
    <String, dynamic>{
      'donationforRider': instance.donationforRider,
    };

DonationforRider _$DonationforRiderFromJson(Map<String, dynamic> json) {
  return DonationforRider(
    json['id'],
    json['updated_at'],
    json['address'],
    json['pickupDate'],
    json['rider'] == null
        ? null
        : Rider.fromJson(json['rider'] as Map<String, dynamic>),
    json['doner'] == null
        ? null
        : Doner.fromJson(json['doner'] as Map<String, dynamic>),
    json['donerId'],
    json['incident'] == null
        ? null
        : Incident.fromJson(json['incident'] as Map<String, dynamic>),
    json['incidentId'],
    json['isCancel'],
    json['lat'],
    json['lng'],
    (json['photo'] as List)
        ?.map(
            (e) => e == null ? null : Photo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['pickupTime'],
    json['riderId'],
    json['shareMessage'],
    json['status'],
  );
}

Map<String, dynamic> _$DonationforRiderToJson(DonationforRider instance) =>
    <String, dynamic>{
      'id': instance.id,
      'pickupDate': instance.pickupDate,
      'pickupTime': instance.pickupTime,
      'incidentId': instance.incidentId,
      'riderId': instance.riderId,
      'donerId': instance.donerId,
      'lat': instance.lat,
      'lng': instance.lng,
      'address': instance.address,
      'shareMessage': instance.shareMessage,
      'status': instance.status,
      'isCancel': instance.isCancel,
      'updated_at': instance.updated_at,
      'incident': instance.incident,
      'photo': instance.photo,
      'rider': instance.rider,
      'doner': instance.doner,
    };

Incident _$IncidentFromJson(Map<String, dynamic> json) {
  return Incident(
    json['id'],
    json['beneficiarId'],
    json['lat'],
    json['lng'],
    json['messageForDoner'],
    json['situation'],
    json['status'],
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

Doner _$DonerFromJson(Map<String, dynamic> json) {
  return Doner(
    json['id'],
    json['name'],
    json['device_id'],
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
      'device_id': instance.device_id,
      'image': instance.image,
      'lat': instance.lat,
      'lng': instance.lng,
    };
