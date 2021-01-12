import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/cate_repo.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/data/repo/product_repo.dart';
import 'package:flutter_watch_shop_app/data/repo/user_repo.dart';
import 'package:flutter_watch_shop_app/event/add_to_cart_event.dart';
import 'package:flutter_watch_shop_app/shared/model/category.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/shopping_cart.dart';
import 'package:flutter_watch_shop_app/shared/model/user_data.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BaseBloc with ChangeNotifier {
  // final ProductRepo _productRepo;
  // final OrderRepo _orderRepo;
  // final CateRepo _cateRepo;
  //
  //
  // static HomeBloc _instance;
  //
  // static HomeBloc getInstance({
  //   @required ProductRepo productRepo,
  //   @required OrderRepo orderRepo,
  //   @required CateRepo cateRepo,
  // }) {
  //   if (_instance == null) {
  //     _instance = HomeBloc._internal(
  //       productRepo: productRepo,
  //       orderRepo: orderRepo,
  //       cateRepo: cateRepo,
  //     );
  //   }
  //   return _instance;
  // }
  //
  // HomeBloc._internal({
  //   @required ProductRepo productRepo,
  //   @required OrderRepo orderRepo,
  //   @required CateRepo cateRepo,
  // })  : _productRepo = productRepo,
  //       _orderRepo = orderRepo,
  //       _cateRepo = cateRepo;
  //

   ProductRepo _productRepo;
   OrderRepo _orderRepo;
   CateRepo _cateRepo;
   UserRepo _userRepo;


  HomeBloc({ProductRepo productRepo, OrderRepo orderRepo, CateRepo cateRepo, UserRepo userRepo}) {
    _productRepo = productRepo;
    _cateRepo = cateRepo;
    _orderRepo = orderRepo;
    _userRepo = userRepo;
  }

  var _shoppingCart = ShoppingCart();

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

   Stream<List<Category>> getCateList() {
     return Stream<List<Category>>.fromFuture(
       _cateRepo.getCategoryList(),
     );
   }

  Stream<List<Product>> getProductList() {
    return Stream<List<Product>>.fromFuture(
      _productRepo.getProductList(),
    );
  }

   Stream<UserData> getUserProfile() {
     return Stream<UserData>.fromFuture(
       _userRepo.getProfile(),
     );
   }


   @override
  void dispose() {
    super.dispose();
    print("homepage close");
    _shoppingCardSubject.close();
  }
}
