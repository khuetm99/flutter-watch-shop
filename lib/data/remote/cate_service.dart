import 'package:dio/dio.dart';
import 'package:flutter_watch_shop_app/network/watch_client.dart';

class CateService {
  Future<Response> getCateList() {
    return WatchClient.instance.dio.get(
      '/cate/list',
    );
  }
}
