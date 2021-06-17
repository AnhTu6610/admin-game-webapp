// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_product_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllProductRes _$AllProductResFromJson(Map<String, dynamic> json) {
  return AllProductRes(
    json['code'] as int?,
    json['mess'] as String?,
    _fromJsonFunc(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AllProductResToJson(AllProductRes instance) =>
    <String, dynamic>{
      'code': instance.code,
      'mess': instance.mess,
      'data': instance.data,
    };

CatDetail _$CatDetailFromJson(Map<String, dynamic> json) {
  return CatDetail(
    json['nameCat'] as String?,
    (json['products'] as List<dynamic>?)
        ?.map((e) => ProductDetail.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$CatDetailToJson(CatDetail instance) => <String, dynamic>{
      'nameCat': instance.nameCat,
      'products': instance.products,
    };

ProductDetail _$ProductDetailFromJson(Map<String, dynamic> json) {
  return ProductDetail(
    (json['image'] as List<dynamic>?)?.map((e) => e as String).toList(),
    json['comment'] as List<dynamic>?,
    json['_id'] as String?,
    json['name'] as String?,
    json['status'] as String?,
    json['category'] as String?,
    json['description'] as String?,
  );
}

Map<String, dynamic> _$ProductDetailToJson(ProductDetail instance) =>
    <String, dynamic>{
      'image': instance.image,
      'comment': instance.comment,
      '_id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'category': instance.category,
      'description': instance.description,
    };
