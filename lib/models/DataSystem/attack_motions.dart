import 'package:json_annotation/json_annotation.dart';

part 'attack_motions.g.dart';

@JsonSerializable()
class AttackMotion {
  int type;
  int weaponImageId;

  AttackMotion({
    required this.type,
    required this.weaponImageId,
  });

  factory AttackMotion.fromJson(Map<String, dynamic> json) => _$AttackMotionFromJson(json);
  Map<String, dynamic> toJson() => _$AttackMotionToJson(this);
}
