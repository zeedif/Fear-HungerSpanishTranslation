import 'package:json_annotation/json_annotation.dart';

import 'Common/trait.dart';

part 'weapon.g.dart';

@JsonSerializable()
class Weapon {
  int id;
  int animationId;
  String description;
  int etypeId;
  List<Trait> traits;
  int iconIndex;
  String name;
  String note;
  List<int> params;
  int price;
  int wtypeId;

  Weapon({
    required this.id,
    required this.animationId,
    required this.description,
    required this.etypeId,
    required this.traits,
    required this.iconIndex,
    required this.name,
    required this.note,
    required this.params,
    required this.price,
    required this.wtypeId,
  });

  factory Weapon.fromJson(Map<String, dynamic> json) => _$WeaponFromJson(json);
  Map<String, dynamic> toJson() => _$WeaponToJson(this);
}
