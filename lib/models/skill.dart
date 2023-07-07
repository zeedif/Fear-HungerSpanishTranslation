import 'package:json_annotation/json_annotation.dart';

import 'Common/damage.dart';
import 'Common/effect.dart';

part 'skill.g.dart';

@JsonSerializable()
class Skill {
  int id;
  int animationId;
  Damage damage;
  String description;
  List<Effect> effects;
  int hitType;
  int iconIndex;
  String message1;
  String message2;
  int mpCost;
  String name;
  String note;
  int occasion;
  int repeats;
  int requiredWtypeId1;
  int requiredWtypeId2;
  int scope;
  int speed;
  int stypeId;
  int successRate;
  int tpCost;
  int tpGain;

  Skill({
    required this.id,
    required this.animationId,
    required this.damage,
    required this.description,
    required this.effects,
    required this.hitType,
    required this.iconIndex,
    required this.message1,
    required this.message2,
    required this.mpCost,
    required this.name,
    required this.note,
    required this.occasion,
    required this.repeats,
    required this.requiredWtypeId1,
    required this.requiredWtypeId2,
    required this.scope,
    required this.speed,
    required this.stypeId,
    required this.successRate,
    required this.tpCost,
    required this.tpGain,
  });

  factory Skill.fromJson(Map<String, dynamic> json) => _$SkillFromJson(json);
  Map<String, dynamic> toJson() => _$SkillToJson(this);
}
