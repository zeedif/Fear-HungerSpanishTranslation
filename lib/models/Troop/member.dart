import 'package:json_annotation/json_annotation.dart';

part 'member.g.dart';

@JsonSerializable()
class Member {
  int enemyId;
  int x;
  int y;
  bool hidden;

  Member({
    required this.enemyId,
    required this.x,
    required this.y,
    required this.hidden,
  });

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
