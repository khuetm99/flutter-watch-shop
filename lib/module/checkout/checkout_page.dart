import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/base/base_widget.dart';
import 'package:flutter_watch_shop_app/data/remote/order_service.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/event/confirm_order_event.dart';
import 'package:flutter_watch_shop_app/event/delete_cart_event.dart';
import 'package:flutter_watch_shop_app/event/pop_event.dart';
import 'package:flutter_watch_shop_app/event/update_cart_event.dart';
import 'package:flutter_watch_shop_app/module/checkout/checkout_bloc.dart';
import 'package:flutter_watch_shop_app/shared/model/order.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';
import 'package:flutter_watch_shop_app/shared/widget/bloc_listener.dart';
import 'package:flutter_watch_shop_app/shared/widget/btn_cart_action.dart';
import 'package:flutter_watch_shop_app/shared/widget/normal_button.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String orderId = ModalRoute.of(context).settings.arguments;
    return PageContainer(
      di: [
        Provider.value(
          value: orderId,
        ),
        Provider.value(
          value: OrderService(),
        ),
        ProxyProvider2<OrderService, String, OrderRepo>(
          update: (context, orderService, orderId, previous) => OrderRepo(
            orderService: orderService,
            orderId: orderId,
          ),
        ),
      ],
      bloc: [],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Check Out'),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            }),
      ),
      body: ShoppingCartContainer(),
    );
  }
}

class ShoppingCartContainer extends StatefulWidget {
  @override
  _ShoppingCartContainerState createState() => _ShoppingCartContainerState();
}

class _ShoppingCartContainerState extends State<ShoppingCartContainer> {
  handleEvent(BaseEvent event) {
    if (event is ShouldPopEvent) {
      Navigator.pushReplacementNamed(context, '/payment');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CheckoutBloc(
        orderRepo: Provider.of(context),
      ),
      child: Consumer<CheckoutBloc>(
        builder: (context, bloc, child) => BlocListener<CheckoutBloc>(
          listener: handleEvent,
          child: ShoppingCart(bloc),
        ),
      ),
    );
  }
}

class ShoppingCart extends StatefulWidget {
  final CheckoutBloc bloc;

  ShoppingCart(this.bloc);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    super.initState();
    widget.bloc.getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Object>.value(
      value: widget.bloc.orderStream,
      initialData: null,
      catchError: (context, err) {
        return err;
      },
      child: Consumer<Object>(
        builder: (context, data, child) {
          if (data == null) {
            return CartNull();
          }

          if (data is RestError) {
            return Center(
                child: Container(
                child: Text(data.message),
            ));
          }

          if (data is Order) {
            return Column(
              children: <Widget>[
                Expanded(
                  child: ProductListWidget(data.items),
                ),
                ConfirmInfoWidget(data.total),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }
}

class CartNull extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.center,
          child: Container(
              child : Image.asset('assets/empty-cart.png', fit: BoxFit.cover,)
          ),
        ),
      ],
    );
  }
}


class ConfirmInfoWidget extends StatefulWidget {
  final double total;

  ConfirmInfoWidget(this.total);

  @override
  _ConfirmInfoWidgetState createState() => _ConfirmInfoWidgetState();
}

class _ConfirmInfoWidgetState extends State<ConfirmInfoWidget> {

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutBloc>(builder: (context, bloc, child) {
      return Container(
        height: 170,
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                    symbol: '\$',
                    fractionDigits: 0,
                  ), amount: widget.total).output.symbolOnRight}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent),
            ),
            SizedBox(
              height: 20.0,
            ),
            NormalButton(
              title: 'Confirm',
              onPressed: () {
                bloc.event.add(ConfirmOrderEvent());

              },
            ),
          ],
        ),
      );
    });
  }
}

class ProductListWidget extends StatefulWidget {
  final List<Product> productList;

  ProductListWidget(this.productList);

  @override
  _ProductListWidgetState createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  @override
  Widget build(BuildContext context) {
    var bloc = Provider.of<CheckoutBloc>(context);
    widget.productList.sort((p1, p2) => p1.price.compareTo(p2.price));
    return ListView.builder(
      itemCount: widget.productList.length,
      itemBuilder: (context, index) => _buildRow(widget.productList[index], bloc),
    );
  }

  Widget _buildRow(Product product, CheckoutBloc bloc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                product.productImage,
                width: 90,
                height: 140,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.0,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Giá: ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                          symbol: '\$',
                          fractionDigits: 0,
                        ), amount: product.price).output.symbolOnRight}',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  _buildCartAction(product, bloc),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                bloc.event.add(DeleteCartEvent(product));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartAction(Product product, CheckoutBloc bloc) {
    return Row(
      children: <Widget>[
        BtnCartAction(
          title: '-',
          onPressed: () {
            if (product.quantity == 1) {
              return;
            }
            product.quantity = product.quantity - 1;
            bloc.event.add(UpdateCartEvent(product));
          },
        ),
        SizedBox(
          width: 15,
        ),
        Text('${product.quantity}',
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: Colors.red)),
        SizedBox(
          width: 15,
        ),
        BtnCartAction(
          title: '+',
          onPressed: () {
            product.quantity = product.quantity + 1;
            bloc.event.add(UpdateCartEvent(product));
          },
        ),
      ],
    );
  }
}
