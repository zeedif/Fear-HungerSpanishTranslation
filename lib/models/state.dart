import 'package:json_annotation/json_annotation.dart';

import 'Common/trait.dart';

part 'state.g.dart';

@JsonSerializable()
class State {
  int id;
  int autoRemovalTiming;
  int chanceByDamage;
  @JsonKey(includeIfNull: false)
  String? description;
  int iconIndex;
  int maxTurns;
  String message1;
  String message2;
  String message3;
  String message4;
  int minTurns;
  int motion;
  String name;
  String note;
  int overlay;
  int priority;
  @JsonKey(includeIfNull: false)
  bool? releaseByDamage;
  bool removeAtBattleEnd;
  bool removeByDamage;
  bool removeByRestriction;
  bool removeByWalking;
  int restriction;
  int stepsToRemove;
  List<Trait> traits;

  State({
    required this.id,
    required this.autoRemovalTiming,
    required this.chanceByDamage,
    required this.iconIndex,
    required this.maxTurns,
    required this.message1,
    required this.message2,
    required this.message3,
    required this.message4,
    required this.minTurns,
    required this.motion,
    required this.name,
    required this.note,
    required this.overlay,
    required this.priority,
    this.releaseByDamage,
    required this.removeAtBattleEnd,
    required this.removeByDamage,
    required this.removeByRestriction,
    required this.removeByWalking,
    required this.restriction,
    required this.stepsToRemove,
    required this.traits,
    this.description,
  });

  factory State.fromJson(Map<String, dynamic> json) => _$StateFromJson(json);
  Map<String, dynamic> toJson() => _$StateToJson(this);
}
