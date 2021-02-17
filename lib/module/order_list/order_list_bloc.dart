import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/shared/model/order_detail.dart';

import 'package:rxdart/rxdart.dart';

class OrderListBloc extends BaseBloc with ChangeNotifier {
  OrderRepo _orderRepo;

  OrderListBloc({@required OrderRepo orderRepo}) {
    _orderRepo = orderRepo;
  }

  final _orderDetaiSubject = BehaviorSubject<OrderDetail>();

  Stream<OrderDetail> get orderdetailStream => _orderDetaiSubject.stream;
  Sink<OrderDetail> get orderdetailSink => _orderDetaiSubject.sink;


  @override
  void dispatchEvent(BaseEvent event) {}

  Stream<List<OrderDetail>> getOrderList() {
    return Stream<List<OrderDetail>>.fromFuture(
      _orderRepo.getOrderList(),
    );
  }


  Stream<List<OrderDetail>> getOrderDeletedList() {
    return Stream<List<OrderDetail>>.fromFuture(
      _orderRepo.getOrderDeletedList(),
    );
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _orderDetaiSubject.close();
  }
}
