import 'package:json_annotation/json_annotation.dart';

part 'command.g.dart';

@JsonSerializable()
class Command {
  int code;
  int? indent;
  @JsonKey(includeIfNull: false)
  /*
  This can be an empty list, null, or contain the following types of elements:

  - List()
  - List<int>
  - List<String>
  - List<int, String>
  - List<String, int>
  - List<int, int, int>
  - List<int, int, String>
  - List<String, int, int>
  - List<String, String, String>
  - List<Audio>
  - List<Command>
  ...
  */
  List<dynamic>? parameters;

  Command({
    required this.code,
    required this.indent,
    this.parameters,
  });

  factory Command.fromJson(Map<String, dynamic> json) => _$CommandFromJson(json);
  Map<String, dynamic> toJson() => _$CommandToJson(this);
}
