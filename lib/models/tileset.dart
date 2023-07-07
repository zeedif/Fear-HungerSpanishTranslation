import 'package:json_annotation/json_annotation.dart';

part 'tileset.g.dart';

@JsonSerializable()
class Tileset {
  int id;
  List<int> flags;
  int mode;
  String name;
  String note;
  List<String> tilesetNames;

  Tileset({
    required this.id,
    required this.flags,
    required this.mode,
    required this.name,
    required this.note,
    required this.tilesetNames,
  });

  factory Tileset.fromJson(Map<String, dynamic> json) => _$TilesetFromJson(json);
  Map<String, dynamic> toJson() => _$TilesetToJson(this);
}
