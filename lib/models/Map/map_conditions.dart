import 'package:json_annotation/json_annotation.dart';

part 'map_conditions.g.dart';

@JsonSerializable()
class MapConditions {
  int actorId;
  bool actorValid;
  int itemId;
  bool itemValid;
  String selfSwitchCh;
  bool selfSwitchValid;
  int switch1Id;
  bool switch1Valid;
  int switch2Id;
  bool switch2Valid;
  int variableId;
  bool variableValid;
  int variableValue;

  MapConditions({
    required this.actorId,
    required this.actorValid,
    required this.itemId,
    required this.itemValid,
    required this.selfSwitchCh,
    required this.selfSwitchValid,
    required this.switch1Id,
    required this.switch1Valid,
    required this.switch2Id,
    required this.switch2Valid,
    required this.variableId,
    required this.variableValid,
    required this.variableValue,
  });

  factory MapConditions.fromJson(Map<String, dynamic> json) => _$MapConditionsFromJson(json);
  Map<String, dynamic> toJson() => _$MapConditionsToJson(this);
}
