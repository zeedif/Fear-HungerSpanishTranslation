import 'package:json_annotation/json_annotation.dart';

part 'terms.g.dart';

@JsonSerializable()
class Terms {
  List<String> basic;
  List<String?> commands;
  List<String> params;
  Map<String, String> messages;

  Terms({
    required this.basic,
    required this.commands,
    required this.params,
    required this.messages,
  });

  factory Terms.fromJson(Map<String, dynamic> json) => _$TermsFromJson(json);
  Map<String, dynamic> toJson() => _$TermsToJson(this);
}
