import 'package:flutter_watch_shop_app/shared/model/product.dart';

class OrderDetail {
  String orderId;
  double total;
  String status;
  String userName;
  String createdAt;
  String updatedAt;


  static List<Product> parseProductList(map) {
    var list = map['items'] as List;
    return list.map((product) => Product.fromJson(product)).toList();
  }

  OrderDetail({this.orderId, this.total, this.status, this.userName, this.createdAt});

  static List<OrderDetail> parseOrderDetailList(map) {
    var list = map['data'] as List;
    return list.map((order) => OrderDetail.fromJson(order)).toList();
  }

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    orderId: json["orderId"],
    total: double.parse(json["total"]?.toString()),
    status : json["status"],
    createdAt : json["updatedAt"],
    userName : json["userName"],
  );

}
