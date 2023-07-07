import 'package:json_annotation/json_annotation.dart';

part 'drop_item.g.dart';

@JsonSerializable()
class DropItem {
  int dataId;
  int denominator;
  int kind;

  DropItem({
    required this.dataId,
    required this.denominator,
    required this.kind,
  });

  factory DropItem.fromJson(Map<String, dynamic> json) => _$DropItemFromJson(json);
  Map<String, dynamic> toJson() => _$DropItemToJson(this);
}
