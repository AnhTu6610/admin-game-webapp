import 'package:json_annotation/json_annotation.dart';
part 'body_update_sts_cate.g.dart';

@JsonSerializable()
class BodyUpdateStscate {
  String category;
  String status;
  BodyUpdateStscate({
    required this.category,
    required this.status,
  });

  factory BodyUpdateStscate.fromJson(Map<String, dynamic> json) => _$BodyUpdateStscateFromJson(json);

  Map<String, dynamic> toJson() => _$BodyUpdateStscateToJson(this);
}
