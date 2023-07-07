import 'package:json_annotation/json_annotation.dart';

part 'conditions.g.dart';

@JsonSerializable()
class Conditions {
  int actorHp;
  int actorId;
  bool actorValid;
  int enemyHp;
  int enemyIndex;
  bool enemyValid;
  int switchId;
  bool switchValid;
  int turnA;
  int turnB;
  bool turnEnding;
  bool turnValid;

  Conditions({
    required this.actorHp,
    required this.actorId,
    required this.actorValid,
    required this.enemyHp,
    required this.enemyIndex,
    required this.enemyValid,
    required this.switchId,
    required this.switchValid,
    required this.turnA,
    required this.turnB,
    required this.turnEnding,
    required this.turnValid,
  });

  factory Conditions.fromJson(Map<String, dynamic> json) => _$ConditionsFromJson(json);
  Map<String, dynamic> toJson() => _$ConditionsToJson(this);
}
