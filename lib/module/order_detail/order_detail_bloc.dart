import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/shared/model/order.dart';
import 'package:flutter_watch_shop_app/shared/model/order_detail.dart';
import 'package:flutter_watch_shop_app/shared/model/order_list_detail.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailBloc extends BaseBloc with ChangeNotifier {
  final OrderRepo _orderRepo;

  OrderDetailBloc({
    @required OrderRepo orderRepo,
  }) : _orderRepo = orderRepo;

  final _orderSubject = BehaviorSubject<OrderListDetail>();

  Stream<OrderListDetail> get orderStream => _orderSubject.stream;
  Sink<OrderListDetail> get orderSink => _orderSubject.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
    }
  }

  getOrderDetailForOrderList() {
    Stream<OrderListDetail>.fromFuture(
      _orderRepo.getOrderDetailForOrderList(),
    ).listen((order) {
      orderSink.add(order);
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('checkout close');
    _orderSubject.close();
  }
}
