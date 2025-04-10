import 'package:json_annotation/json_annotation.dart';

part 'team.g.dart';

@JsonSerializable()
class Team {
  final String? id;
  final String? ownerId;
  final String? teamName;
  final String? teamDescription;

  Team({this.id, this.ownerId, this.teamName, this.teamDescription});

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
  Map<String, dynamic> toJson() => _$TeamToJson(this);
}
