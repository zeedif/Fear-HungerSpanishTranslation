import 'package:json_annotation/json_annotation.dart';

import '../Common/command.dart';
import 'image.dart';
import 'map_conditions.dart';
import 'move_route.dart';

part 'map_page.g.dart';

@JsonSerializable()
class MapPage {
  MapConditions conditions;
  bool directionFix;
  Image image;
  List<Command> list;
  int moveFrequency;
  MoveRoute moveRoute;
  int moveSpeed;
  int moveType;
  int priorityType;
  bool stepAnime;
  bool through;
  int trigger;
  bool walkAnime;

  MapPage({
    required this.conditions,
    required this.directionFix,
    required this.image,
    required this.list,
    required this.moveFrequency,
    required this.moveRoute,
    required this.moveSpeed,
    required this.moveType,
    required this.priorityType,
    required this.stepAnime,
    required this.through,
    required this.trigger,
    required this.walkAnime,
  });

  factory MapPage.fromJson(Map<String, dynamic> json) => _$MapPageFromJson(json);
  Map<String, dynamic> toJson() => _$MapPageToJson(this);
}
