import 'package:json_annotation/json_annotation.dart';

import 'Troop/member.dart';
import 'Troop/page.dart';

part 'troop.g.dart';

@JsonSerializable()
class Troop {
  int id;
  List<Member> members;
  String name;
  List<Page> pages;

  Troop({
    required this.id,
    required this.members,
    required this.name,
    required this.pages,
  });

  factory Troop.fromJson(Map<String, dynamic> json) => _$TroopFromJson(json);
  Map<String, dynamic> toJson() => _$TroopToJson(this);
}
