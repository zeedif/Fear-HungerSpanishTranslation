import 'package:json_annotation/json_annotation.dart';

import '../Common/command.dart';
import 'conditions.dart';

part 'page.g.dart';

@JsonSerializable()
class Page {
  Conditions conditions;
  List<Command> list;
  int span;

  Page({
    required this.conditions,
    required this.list,
    required this.span,
  });

  factory Page.fromJson(Map<String, dynamic> json) => _$PageFromJson(json);
  Map<String, dynamic> toJson() => _$PageToJson(this);
}
