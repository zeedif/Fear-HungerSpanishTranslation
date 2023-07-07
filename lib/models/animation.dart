import 'package:json_annotation/json_annotation.dart';

import 'Animation/timing.dart';

part 'animation.g.dart';

@JsonSerializable()
class Animation {
  int id;
  int animation1Hue;
  String animation1Name;
  int animation2Hue;
  String animation2Name;
  List<List<List<double>>> frames;
  String name;
  int position;
  List<Timing> timings;

  Animation({
    required this.id,
    required this.animation1Hue,
    required this.animation1Name,
    required this.animation2Hue,
    required this.animation2Name,
    required this.frames,
    required this.name,
    required this.position,
    required this.timings,
  });

  factory Animation.fromJson(Map<String, dynamic> json) => _$AnimationFromJson(json);
  Map<String, dynamic> toJson() => _$AnimationToJson(this);
}
