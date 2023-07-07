import 'package:json_annotation/json_annotation.dart';

part 'action.g.dart';

@JsonSerializable()
class Action {
  int conditionParam1;
  int conditionParam2;
  int conditionType;
  int rating;
  int skillId;

  Action({
    required this.conditionParam1,
    required this.conditionParam2,
    required this.conditionType,
    required this.rating,
    required this.skillId,
  });

  factory Action.fromJson(Map<String, dynamic> json) => _$ActionFromJson(json);
  Map<String, dynamic> toJson() => _$ActionToJson(this);
}
