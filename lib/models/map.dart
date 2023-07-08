import 'package:json_annotation/json_annotation.dart';

import 'Map/event.dart';
import 'System/audio.dart';

part 'map.g.dart';

@JsonSerializable()
class DataMap {
  bool autoplayBgm;
  bool autoplayBgs;
  String battleback1Name;
  String battleback2Name;
  Audio bgm;
  Audio bgs;
  bool disableDashing;
  String displayName;
  List<dynamic> encounterList; // ! Check this
  int encounterStep;
  int height;
  String note;
  bool parallaxLoopX;
  bool parallaxLoopY;
  String parallaxName;
  bool parallaxShow;
  int parallaxSx;
  int parallaxSy;
  int scrollType;
  bool specifyBattleback;
  int tilesetId;
  int width;
  List<int> data;
  List<Event?> events;

  DataMap({
    required this.autoplayBgm,
    required this.autoplayBgs,
    required this.battleback1Name,
    required this.battleback2Name,
    required this.bgm,
    required this.bgs,
    required this.disableDashing,
    required this.displayName,
    required this.encounterList,
    required this.encounterStep,
    required this.height,
    required this.note,
    required this.parallaxLoopX,
    required this.parallaxLoopY,
    required this.parallaxName,
    required this.parallaxShow,
    required this.parallaxSx,
    required this.parallaxSy,
    required this.scrollType,
    required this.specifyBattleback,
    required this.tilesetId,
    required this.width,
    required this.data,
    required this.events,
  });

  factory DataMap.fromJson(Map<String, dynamic> json) => _$DataMapFromJson(json);
  Map<String, dynamic> toJson() => _$DataMapToJson(this);
}
