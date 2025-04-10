// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Team _$TeamFromJson(Map<String, dynamic> json) => Team(
  id: json['id'] as String?,
  teamName: json['teamName'] as String?,
  teamDescription: json['teamDescription'] as String?,
);

Map<String, dynamic> _$TeamToJson(Team instance) => <String, dynamic>{
  'id': instance.id,
  'teamName': instance.teamName,
  'teamDescription': instance.teamDescription,
};
