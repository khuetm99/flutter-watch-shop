import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';

class DeleteCartEvent extends BaseEvent {
  Product product;
  DeleteCartEvent(this.product);
}
