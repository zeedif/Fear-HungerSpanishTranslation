import 'package:json_annotation/json_annotation.dart';

part 'image.g.dart';

@JsonSerializable()
class Image {
  int tileId;
  String characterName;
  int direction;
  int pattern;
  int characterIndex;

  Image({
    required this.tileId,
    required this.characterName,
    required this.direction,
    required this.pattern,
    required this.characterIndex,
  });

  factory Image.fromJson(Map<String, dynamic> json) => _$ImageFromJson(json);
  Map<String, dynamic> toJson() => _$ImageToJson(this);
}
