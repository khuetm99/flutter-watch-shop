import 'package:dio/dio.dart';
import 'package:flutter_watch_shop_app/network/watch_client.dart';

class ProductService {
  Future<Response> getProductList() {
    return WatchClient.instance.dio.get(
      '/product/list',
    );
  }
  Future<Response> getProductListByName(String productName) {
    return WatchClient.instance.dio.get(
      '/product/search/$productName',
    );
  }
  Future<Response> getProductListByCate(String cateId) {
    return WatchClient.instance.dio.get(
      '/product/cate/$cateId',
    );
  }
}
