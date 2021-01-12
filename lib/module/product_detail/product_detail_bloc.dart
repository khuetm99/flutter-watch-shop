import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/data/repo/product_repo.dart';
import 'package:flutter_watch_shop_app/event/add_to_cart_event.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/shopping_cart.dart';
import 'package:rxdart/rxdart.dart';

class ProductDetailBloc extends BaseBloc with ChangeNotifier {
  final ProductRepo _productRepo;
  final OrderRepo _orderRepo;

  var _shoppingCart = ShoppingCart();

  static ProductDetailBloc _instance;

  static ProductDetailBloc getInstance({
    @required ProductRepo productRepo,
    @required OrderRepo orderRepo,
  }) {
    if (_instance == null) {
      _instance = ProductDetailBloc._internal(
        productRepo: productRepo,
        orderRepo: orderRepo,
      );
    }
    return _instance;
  }

  ProductDetailBloc._internal({
    @required ProductRepo productRepo,
    @required OrderRepo orderRepo,
  })  : _productRepo = productRepo,
        _orderRepo = orderRepo;

  final _shoppingCardSubject = BehaviorSubject<ShoppingCart>();

  Stream<ShoppingCart> get shoppingCartStream => _shoppingCardSubject.stream;
  Sink<ShoppingCart> get shoppingCartSink => _shoppingCardSubject.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case AddToCartEvent:
        handleAddToCart(event);
        break;
    }
  }

  handleAddToCart(event) {
    AddToCartEvent addToCartEvent = event as AddToCartEvent;
    _orderRepo.addToCart(addToCartEvent.product).then((shoppingCart) {
      _shoppingCart.orderId = shoppingCart.orderId;
      shoppingCartSink.add(shoppingCart);
    });
  }

  getShoppingCartInfo() {
    Stream<ShoppingCart>.fromFuture(_orderRepo.getShoppingCartInfo()).listen(
            (shoppingCart) {
          _shoppingCart = shoppingCart;
          shoppingCartSink.add(shoppingCart);
        }, onError: (err) {
      _shoppingCardSubject.addError(err);
    });
  }

  @override
  void dispose() {
    super.dispose();
    print("product detail close");
    _shoppingCardSubject.close();
  }
}
