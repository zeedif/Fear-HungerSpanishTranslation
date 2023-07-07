import 'package:json_annotation/json_annotation.dart';

part 'test_battlers.g.dart';

@JsonSerializable()
class TestBattlers {
  int actorId;
  List<int> equips;
  int level;

  TestBattlers({
    required this.actorId,
    required this.equips,
    required this.level,
  });

  factory TestBattlers.fromJson(Map<String, dynamic> json) => _$TestBattlersFromJson(json);
  Map<String, dynamic> toJson() => _$TestBattlersToJson(this);
}
