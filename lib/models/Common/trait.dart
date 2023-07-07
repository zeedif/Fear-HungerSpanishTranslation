import 'package:json_annotation/json_annotation.dart';

part 'trait.g.dart';

@JsonSerializable()
class Trait {
  int code;
  int dataId;
  double value;

  Trait({
    required this.code,
    required this.dataId,
    required this.value,
  });

  factory Trait.fromJson(Map<String, dynamic> json) => _$TraitFromJson(json);
  Map<String, dynamic> toJson() => _$TraitToJson(this);
}
