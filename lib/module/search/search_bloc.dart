import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/product_repo.dart';
import 'package:flutter_watch_shop_app/event/search_event.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';

import 'package:rxdart/rxdart.dart';

class SearchBloc extends BaseBloc with ChangeNotifier {
  ProductRepo _productRepo;

  SearchBloc({@required ProductRepo productRepo}) {
    _productRepo = productRepo;
  }

  final _searchSubject = BehaviorSubject<List<Product>>();

  Stream<List<Product>> get searchStream => _searchSubject.stream;
  Sink<List<Product>> get searchSink => _searchSubject.sink;


  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SearchEvent:
        handleSearch(event);
        break;
    }
  }

  handleSearch(event) {
    SearchEvent e = event as SearchEvent;
     Stream<List<Product>>.fromFuture(_productRepo.getProductListByName(e.productName)).listen((event) {
      searchSink.add(event);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchSubject.close();
  }
}
