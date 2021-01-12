import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';

class AddToCartEvent extends BaseEvent {
  Product product;

  AddToCartEvent(this.product);
}
