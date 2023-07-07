import 'package:json_annotation/json_annotation.dart';

import 'Common/damage.dart';
import 'Common/effect.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  int id;
  int animationId;
  bool consumable;
  Damage damage;
  String description;
  List<Effect> effects;
  int hitType;
  int iconIndex;
  int itypeId;
  String name;
  String note;
  int occasion;
  int price;
  int repeats;
  int scope;
  int speed;
  int successRate;
  int tpGain;

  Item({
    required this.id,
    required this.animationId,
    required this.consumable,
    required this.damage,
    required this.description,
    required this.effects,
    required this.hitType,
    required this.iconIndex,
    required this.itypeId,
    required this.name,
    required this.note,
    required this.occasion,
    required this.price,
    required this.repeats,
    required this.scope,
    required this.speed,
    required this.successRate,
    required this.tpGain,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
