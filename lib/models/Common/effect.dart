import 'package:json_annotation/json_annotation.dart';

part 'effect.g.dart';

@JsonSerializable()
class Effect {
  int code;
  int dataId;
  double value1;
  int value2;

  Effect({
    required this.code,
    required this.dataId,
    required this.value1,
    required this.value2,
  });

  factory Effect.fromJson(Map<String, dynamic> json) => _$EffectFromJson(json);
  Map<String, dynamic> toJson() => _$EffectToJson(this);
}
