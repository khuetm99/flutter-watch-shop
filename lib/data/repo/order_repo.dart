import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/data/remote/order_service.dart';
import 'package:flutter_watch_shop_app/shared/model/order.dart';
import 'package:flutter_watch_shop_app/shared/model/order_detail.dart';
import 'package:flutter_watch_shop_app/shared/model/order_list_detail.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';
import 'package:flutter_watch_shop_app/shared/model/shopping_cart.dart';


class OrderRepo {
  OrderService _orderService;
  String _orderId;

  OrderRepo({@required OrderService orderService, String orderId})
      : _orderService = orderService,
        _orderId = orderId;

  Future<ShoppingCart> addToCart(Product product) async {
    var c = Completer<ShoppingCart>();
    try {
      var response = await _orderService.addToCart(product);
      var shoppingCart = ShoppingCart.fromJson(response.data['data']);
      c.complete(shoppingCart);
    } on DioError {
      c.completeError(RestError.fromData('Lỗi AddToCart'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<ShoppingCart> getShoppingCartInfo() async {
    var c = Completer<ShoppingCart>();
    try {
      var response = await _orderService.countShoppingCart();
      var shoppingCart = ShoppingCart.fromJson(response.data['data']);
      c.complete(shoppingCart);
    } on DioError {
      c.completeError(RestError.fromData('Lỗi lấy thông tin shopping cart'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<Order> getOrderDetail() async {
    var c = Completer<Order>();
    try {
      var response = await _orderService.orderDetail(_orderId);
      if (response.data['data']['items'] != null) {
        var order = Order.fromJson(response.data['data']);
        c.complete(order);
      } else {
        c.completeError(RestError.fromData('Không lấy được đơn hàng'));
      }
    } on DioError {
      c.completeError(RestError.fromData('Không lấy được đơn hàng'));
    } catch (e) {
      c.completeError(RestError.fromData(e.toString()));
    }
    return c.future;
  }

  Future<OrderListDetail> getOrderDetailForOrderList() async {
    var c = Completer<OrderListDetail>();
    try {
      var response = await _orderService.orderListDetail(_orderId);
      if (response.data['data']['items'] != null) {
        var order = OrderListDetail.fromJson(response.data['data']);
        c.complete(order);
      } else {
        c.completeError(RestError.fromData('Không lấy được đơn hàng'));
      }
    } on DioError {
      c.completeError(RestError.fromData('Không lấy được đơn hàng'));
    } catch (e) {
      c.completeError(RestError.fromData(e.toString()));
    }
    return c.future;
  }

  Future<List<OrderDetail>> getOrderList() async {
    var c = Completer<List<OrderDetail>>();
    try {
      var response = await _orderService.orderList();
      var orderList = OrderDetail.parseOrderDetailList(response.data);
      c.complete(orderList);
    } on DioError {
      c.completeError(RestError.fromData('Không có dữ liệu'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }


  Future<bool> updateOrder(Product product) async {
    var c = Completer<bool>();
    try {
      await _orderService.updateOrder(product);
      c.complete(true);
    } on DioError {
      c.completeError(RestError.fromData('Lỗi update đơn hàng'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<bool> removeOrder(Product product) async {
    var c = Completer<bool>();
    try {
      await _orderService.deleteOrder(product);
      c.complete(true);
    } on DioError {
      c.completeError(RestError.fromData('Lỗi update đơn hàng'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }


  Future<bool> confirmOrder() async {
    var c = Completer<bool>();
    try {
      await _orderService.confirm(_orderId);
      c.complete(true);
    } on DioError {
      c.completeError(RestError.fromData('Lỗi confirm đơn hàng'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }
}
