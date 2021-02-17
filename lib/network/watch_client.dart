import 'package:dio/dio.dart';
import 'package:flutter_watch_shop_app/data/spref/spref.dart';
import 'package:flutter_watch_shop_app/shared/constant.dart';

//10.0.2.2 virtual
//ipconfig v4 real device
class WatchClient {
  static BaseOptions _options = new BaseOptions(
    baseUrl: "http://192.168.100.7:3000",
    connectTimeout: 5000,
    receiveTimeout: 3000,
  );
  static Dio _dio = Dio(_options);

  WatchClient._internal() {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (Options myOption) async {
      var token = await SPref.instance.get(SPrefCache.KEY_TOKEN);
      if (token != null) {
        myOption.headers["Authorization"] = "Bearer " + token;
      }

      return myOption;
    }));
  }
  static final WatchClient instance = WatchClient._internal();

  Dio get dio => _dio;
}
