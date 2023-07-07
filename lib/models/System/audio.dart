import 'package:json_annotation/json_annotation.dart';

part 'audio.g.dart';

@JsonSerializable()
class Audio {
  String name;
  int pan;
  int pitch;
  int volume;

  Audio({
    required this.name,
    required this.pan,
    required this.pitch,
    required this.volume,
  });

  factory Audio.fromJson(Map<String, dynamic> json) => _$AudioFromJson(json);
  Map<String, dynamic> toJson() => _$AudioToJson(this);
}
