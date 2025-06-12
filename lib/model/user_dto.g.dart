// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
  userId: json['userId'] as String?,
  userName: json['userName'] as String?,
  role: json['role'] as String?,
);

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
  'userId': instance.userId,
  'userName': instance.userName,
  'role': instance.role,
};
