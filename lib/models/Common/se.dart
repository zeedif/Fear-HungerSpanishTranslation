import 'package:json_annotation/json_annotation.dart';

part 'se.g.dart';

@JsonSerializable()
class Se {
  String name;
  int pan;
  int pitch;
  int volume;

  Se({
    required this.name,
    required this.pan,
    required this.pitch,
    required this.volume,
  });

  factory Se.fromJson(Map<String, dynamic> json) => _$SeFromJson(json);
  Map<String, dynamic> toJson() => _$SeToJson(this);
}
