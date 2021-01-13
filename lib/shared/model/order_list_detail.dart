
import 'package:flutter_watch_shop_app/shared/model/product.dart';

class OrderListDetail {
  String orderId;
  double total;
  String status;
  String userName;
  String createdAt;
  String updatedAt;
  List<Product> items;


  static List<Product> parseProductList(map) {
    var list = map['items'] as List;
    return list.map((product) => Product.fromJson(product)).toList();
  }

  OrderListDetail(
      {this.orderId, this.total, this.status, this.userName, this.createdAt, this.items});

  static List<OrderListDetail> parseOrderDetailList(map) {
    var list = map['data'] as List;
    return list.map((order) => OrderListDetail.fromJson(order)).toList();
  }

  factory OrderListDetail.fromJson(Map<String, dynamic> json) =>
      OrderListDetail(
        orderId: json["orderId"],
        total: double.parse(json["total"]?.toString()),
        status: json["status"],
        createdAt: json["updatedAt"],
        userName: json["userName"],
        items: parseProductList(json),
      );
}