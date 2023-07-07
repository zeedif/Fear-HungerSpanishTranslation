import 'package:json_annotation/json_annotation.dart';

import 'Common/command.dart';

part 'common_event.g.dart';

@JsonSerializable()
class CommonEvent {
  int id;
  List<Command> list;
  String name;
  int switchId;
  int trigger;

  CommonEvent({
    required this.id,
    required this.list,
    required this.name,
    required this.switchId,
    required this.trigger,
  });

  factory CommonEvent.fromJson(Map<String, dynamic> json) => _$CommonEventFromJson(json);
  Map<String, dynamic> toJson() => _$CommonEventToJson(this);
}
