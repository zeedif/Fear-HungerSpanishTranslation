import 'package:json_annotation/json_annotation.dart';

import 'Common/trait.dart';

part 'actor.g.dart';

@JsonSerializable()
class Actor {
  int id;
  String battlerName;
  int characterIndex;
  String characterName;
  int classId;
  List<int> equips;
  int faceIndex;
  String faceName;
  List<Trait> traits;
  int initialLevel;
  int maxLevel;
  String name;
  String nickname;
  String note;
  String profile;

  Actor({
    required this.id,
    required this.battlerName,
    required this.characterIndex,
    required this.characterName,
    required this.classId,
    required this.equips,
    required this.faceIndex,
    required this.faceName,
    required this.traits,
    required this.initialLevel,
    required this.maxLevel,
    required this.name,
    required this.nickname,
    required this.note,
    required this.profile,
  });

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);
  Map<String, dynamic> toJson() => _$ActorToJson(this);
}
