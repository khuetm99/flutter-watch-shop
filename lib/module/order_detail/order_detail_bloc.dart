import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/event/destroy_order_event.dart';
import 'package:flutter_watch_shop_app/event/pop_event.dart';
import 'package:flutter_watch_shop_app/shared/model/order_list_detail.dart';
import 'package:rxdart/rxdart.dart';

class OrderDetailBloc extends BaseBloc with ChangeNotifier {
  final OrderRepo _orderRepo;

  OrderDetailBloc({
    @required OrderRepo orderRepo,
  }) : _orderRepo = orderRepo;

  final _orderDetailSubject = BehaviorSubject<OrderListDetail>();

  Stream<OrderListDetail> get orderDetailStream => _orderDetailSubject.stream;
  Sink<OrderListDetail> get orderDetailSink => _orderDetailSubject.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case DestroyOrderEvent:
        handleDestroyOrder(event);
        break;
    }
  }

  handleDestroyOrder(event) {
    _orderRepo.destroyOrder().then((isSuccess) {
      processEventSink.add(ShouldPopEvent());
    });
  }

  getOrderDetailForOrderList() {
    Stream<OrderListDetail>.fromFuture(
      _orderRepo.getOrderDetailForOrderList(),
    ).listen((order) {
      orderDetailSink.add(order);
    });
  }

  @override
  void dispose() {
    super.dispose();
    print('checkout close');
    _orderDetailSubject.close();
  }
}
