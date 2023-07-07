import 'package:FearHungerTranslation/models/DataSystem/audio.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ship.g.dart';

@JsonSerializable()
class Ship {
  Audio bgm;
  int characterIndex;
  String characterName;
  int startMapId;
  int startX;
  int startY;

  Ship({
    required this.bgm,
    required this.characterIndex,
    required this.characterName,
    required this.startMapId,
    required this.startX,
    required this.startY,
  });

  factory Ship.fromJson(Map<String, dynamic> json) => _$ShipFromJson(json);
  Map<String, dynamic> toJson() => _$ShipToJson(this);
}
