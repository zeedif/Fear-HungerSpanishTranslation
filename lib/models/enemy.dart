import 'package:json_annotation/json_annotation.dart';

import 'Common/trait.dart';
import 'Enemy/action.dart';
import 'Enemy/drop_item.dart';

part 'enemy.g.dart';

@JsonSerializable()
class Enemy {
  int id;
  List<Action> actions;
  int battlerHue;
  String battlerName;
  List<DropItem> dropItems;
  int exp;
  List<Trait> traits;
  int gold;
  String name;
  String note;
  List<int> params;

  Enemy({
    required this.id,
    required this.actions,
    required this.battlerHue,
    required this.battlerName,
    required this.dropItems,
    required this.exp,
    required this.traits,
    required this.gold,
    required this.name,
    required this.note,
    required this.params,
  });

  factory Enemy.fromJson(Map<String, dynamic> json) => _$EnemyFromJson(json);
  Map<String, dynamic> toJson() => _$EnemyToJson(this);
}
