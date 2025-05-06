// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Skill _$SkillFromJson(Map<String, dynamic> json) => Skill(
  id: json['id'] as String?,
  skillName: json['skillName'] as String?,
  skillLevel: (json['skillLevel'] as num?)?.toInt(),
);

Map<String, dynamic> _$SkillToJson(Skill instance) => <String, dynamic>{
  'id': instance.id,
  'skillName': instance.skillName,
  'skillLevel': instance.skillLevel,
};
