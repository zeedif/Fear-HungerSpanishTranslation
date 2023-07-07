import 'package:json_annotation/json_annotation.dart';

import 'Class/learning.dart';
import 'Common/trait.dart';

part 'class.g.dart';

@JsonSerializable()
class Class {
  int id;
  List<int> expParams;
  List<Trait> traits;
  List<Learning> learnings;
  String name;
  String note;
  List<List<int>> params;

  Class({
    required this.id,
    required this.expParams,
    required this.traits,
    required this.learnings,
    required this.name,
    required this.note,
    required this.params,
  });

  factory Class.fromJson(Map<String, dynamic> json) => _$ClassFromJson(json);
  Map<String, dynamic> toJson() => _$ClassToJson(this);
}
