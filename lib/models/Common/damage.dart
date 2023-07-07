import 'package:json_annotation/json_annotation.dart';

part 'damage.g.dart';

@JsonSerializable()
class Damage {
  bool critical;
  int elementId;
  String formula;
  int type;
  int variance;

  Damage({
    required this.critical,
    required this.elementId,
    required this.formula,
    required this.type,
    required this.variance,
  });

  factory Damage.fromJson(Map<String, dynamic> json) => _$DamageFromJson(json);
  Map<String, dynamic> toJson() => _$DamageToJson(this);
}
