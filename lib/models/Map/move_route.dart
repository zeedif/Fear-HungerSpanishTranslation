import 'package:json_annotation/json_annotation.dart';

part 'move_route.g.dart';

@JsonSerializable()
class MoveRoute {
  List<dynamic> list;
  bool repeat;
  bool skippable;
  bool wait;

  MoveRoute({
    required this.list,
    required this.repeat,
    required this.skippable,
    required this.wait,
  });

  factory MoveRoute.fromJson(Map<String, dynamic> json) => _$MoveRouteFromJson(json);
  Map<String, dynamic> toJson() => _$MoveRouteToJson(this);
}
