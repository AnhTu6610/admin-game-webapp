import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:trival_admin/data_source/network_data/config/apisubdomain.dart';
import 'package:trival_admin/models/response/all_product_res.dart';

part 'restclient.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {required String baseUrl}) = _RestClient;
  @GET(API.allProduct)
  Future<HttpResponse<AllProductRes>?> getProducts();

  @POST(API.createProduct)
  Future<HttpResponse<dynamic>?> createProduct({
    @Part() required String category,
    @Part() required String name,
    @Part() required String description,
    @Part() required String status,
    @Part(value: "img", contentType: "image/jpeg", fileName: "admin.jpg") required List<List<int>> img,
  });

  @POST(API.updateProduct)
  Future<HttpResponse<dynamic>?> updateProduct({
    @Part() required String id,
    @Part() required String category,
    @Part() required String name,
    @Part() required String description,
    @Part() required String status,
    @Part() required List<String> oldImg,
    @Part(value: "img", contentType: "image/jpeg", fileName: "admin.jpg") required List<List<int>> img,
  });

  @GET(API.deleteProduct)
  Future<HttpResponse<dynamic>?> deleteProducts({@Query("id") required String id});
}
