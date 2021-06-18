import 'package:json_annotation/json_annotation.dart';
import 'package:admin_game/models/response/base_res.dart';
part 'all_product_res.g.dart';

@JsonSerializable()
class AllProductRes extends BaseRes {
  @JsonKey(fromJson: _fromJsonFunc)
  final List<CatDetail>? data;

  AllProductRes(int? code, String? mess, this.data) : super(code, mess);
  factory AllProductRes.fromJson(Map<String, dynamic> json) => _$AllProductResFromJson(json);
  Map<String, dynamic> toJson() => _$AllProductResToJson(this);
}

List<CatDetail>? _fromJsonFunc(Map<String, dynamic> json) {
  List<Map<String, dynamic>> newJson = [];
  json.forEach((key, value) {
    newJson.add({"nameCat": key, "products": value});
  });
  return newJson.map((e) => CatDetail.fromJson(e)).toList();
}

@JsonSerializable()
class CatDetail {
  final String? nameCat;
  final List<ProductDetail>? products;

  CatDetail(this.nameCat, this.products);
  factory CatDetail.fromJson(Map<String, dynamic> json) => _$CatDetailFromJson(json);
  Map<String, dynamic> toJson() => _$CatDetailToJson(this);
}

@JsonSerializable()
class ProductDetail {
  final List<String>? image;
  final List<dynamic>? comment;
  @JsonKey(name: "_id")
  final String? id;
  final String? name;
  final String? status;
  final String? category;
  final String? description;

  ProductDetail(this.image, this.comment, this.id, this.name, this.status, this.category, this.description);
  factory ProductDetail.fromJson(Map<String, dynamic> json) => _$ProductDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailToJson(this);
}
