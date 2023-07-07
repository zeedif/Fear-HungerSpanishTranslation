import 'package:json_annotation/json_annotation.dart';

part 'map_info.g.dart';

@JsonSerializable()
class MapInfo {
  int id;
  bool expanded;
  String name;
  int order;
  int parentId;
  double scrollX;
  double scrollY;

  MapInfo({
    required this.id,
    required this.expanded,
    required this.name,
    required this.order,
    required this.parentId,
    required this.scrollX,
    required this.scrollY,
  });

  factory MapInfo.fromJson(Map<String, dynamic> json) => _$MapInfoFromJson(json);
  Map<String, dynamic> toJson() => _$MapInfoToJson(this);
}
