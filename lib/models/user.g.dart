// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as String,
    json['name'] as String,
    json['displayName'] as String?,
    json['token'] as String?,
    json['gender'] as String?,
    json['avatar'] as String?,
    (json['roles'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'displayName': instance.displayName,
      'token': instance.token,
      'gender': instance.gender,
      'avatar': instance.avatar,
      'roles': instance.roles,
    };
