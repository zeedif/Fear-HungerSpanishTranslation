import 'package:json_annotation/json_annotation.dart';

import 'map_page.dart';

part 'event.g.dart';

@JsonSerializable()
class Event {
  int id;
  String name;
  String note;
  List<MapPage> pages;
  int x;
  int y;

  Event({
    required this.id,
    required this.name,
    required this.note,
    required this.pages,
    required this.x,
    required this.y,
  });

  factory Event.fromJson(Map<String, dynamic> json) => _$EventFromJson(json);
  Map<String, dynamic> toJson() => _$EventToJson(this);
}
