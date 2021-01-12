import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/product_repo.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';

import 'package:rxdart/rxdart.dart';

class CateBloc extends BaseBloc with ChangeNotifier {
  ProductRepo _productRepo;

  CateBloc({@required ProductRepo productRepo}) {
    _productRepo = productRepo;
  }

  @override
  void dispatchEvent(BaseEvent event) {}

  Stream<List<Product>> getProductByCate(String cateId) {
    return Stream<List<Product>>.fromFuture(
      _productRepo.getProductListByCateId(cateId),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
