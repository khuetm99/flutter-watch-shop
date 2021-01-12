import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/event/confirm_order_event.dart';
import 'package:flutter_watch_shop_app/event/delete_cart_event.dart';
import 'package:flutter_watch_shop_app/event/pop_event.dart';
import 'package:flutter_watch_shop_app/event/update_cart_event.dart';
import 'package:flutter_watch_shop_app/shared/model/order.dart';
import 'package:rxdart/rxdart.dart';

class CheckoutBloc extends BaseBloc with ChangeNotifier {
  final OrderRepo _orderRepo;

  CheckoutBloc({
    @required OrderRepo orderRepo,
  }) : _orderRepo = orderRepo;

  final _orderSubject = BehaviorSubject<Order>();

  Stream<Order> get orderStream => _orderSubject.stream;
  Sink<Order> get orderSink => _orderSubject.sink;

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case UpdateCartEvent:
        handleUpdateCart(event);
        break;
      case ConfirmOrderEvent:
        handleConfirmOrder(event);
        break;
      case DeleteCartEvent :
        handleDeleteCart(event);
        break;
    }
  }

  handleConfirmOrder(event) {
    _orderRepo.confirmOrder().then((isSuccess) {
      processEventSink.add(ShouldPopEvent());
    });
  }

  handleUpdateCart(event) {
    UpdateCartEvent e = event as UpdateCartEvent;

    Observable.fromFuture(_orderRepo.updateOrder(e.product))
        .flatMap((_) => Observable.fromFuture(_orderRepo.getOrderDetail()))
        .listen((order) {
      orderSink.add(order);
    });
  }

  handleDeleteCart(event) {
    DeleteCartEvent e = event as DeleteCartEvent;

    Observable.fromFuture(_orderRepo.removeOrder(e.product))
        .flatMap((_) => Observable.fromFuture(_orderRepo.getOrderDetail()))
        .listen((order) {
       orderSink.add(order);
    });
  }

  getOrderDetail() {
    Stream<Order>.fromFuture(
      _orderRepo.getOrderDetail(),
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
