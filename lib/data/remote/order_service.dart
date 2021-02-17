import 'package:dio/dio.dart';
import 'package:flutter_watch_shop_app/network/watch_client.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';

class OrderService {
  Future<Response> countShoppingCart() {
    return WatchClient.instance.dio.get(
      '/order/count',
    );
  }

  Future<Response> addToCart(Product product) {
    return WatchClient.instance.dio.post(
      '/order/add',
      data: product.toJson(),
    );
  }

  Future<Response> orderDetail(String orderId) {
    return WatchClient.instance.dio.get(
      '/order/detail',
      queryParameters: {
        'order_id': orderId,
      },
    );
  }

  Future<Response> orderList() {
    return WatchClient.instance.dio.get(
      '/order/user/list',
    );
  }

  Future<Response> orderdeletedList() {
    return WatchClient.instance.dio.get(
      '/order/user/deleted-list',
    );
  }

// Detail order trong bill của người dùng
  Future<Response> orderListDetail(String orderId) {
    return WatchClient.instance.dio.get(
      '/order/detail/bill',
      queryParameters: {
        'order_id': orderId,
      },
    );
  }

  Future<Response> updateOrder(Product product) {
    return WatchClient.instance.dio.post(
      '/order/update',
      data: {
        'orderId': product.orderId,
        'quantity': product.quantity,
        'productId': product.productId,
      },
    );
  }

  Future<Response> deleteOrder(Product product) {
    return WatchClient.instance.dio.delete(
      '/order/delete',
      data: {
        'orderId': product.orderId,
        'productId': product.productId,
      },
    );
  }

  Future<Response> confirm(String orderId) {
    return WatchClient.instance.dio.post(
      '/order/confirm',
      data: {
        'orderId': orderId,
        'status': 'CONFIRM',
      },
    );
  }

  Future<Response> destroyOrder(String orderId) {
    return WatchClient.instance.dio.post(
      '/order/confirm',
      data: {
        'orderId': orderId,
        'status': 'DELETED',
      },
    );
  }

}
