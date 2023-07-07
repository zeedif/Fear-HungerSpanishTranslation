import 'package:json_annotation/json_annotation.dart';

part 'learning.g.dart';

@JsonSerializable()
class Learning {
  int level;
  String note;
  int skillId;

  Learning({
    required this.level,
    required this.note,
    required this.skillId,
  });

  factory Learning.fromJson(Map<String, dynamic> json) => _$LearningFromJson(json);
  Map<String, dynamic> toJson() => _$LearningToJson(this);
}
