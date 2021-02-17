import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/base/base_widget.dart';
import 'package:flutter_watch_shop_app/data/remote/order_service.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/event/destroy_order_event.dart';
import 'package:flutter_watch_shop_app/event/pop_event.dart';
import 'package:flutter_watch_shop_app/module/order_detail/order_detail_bloc.dart';
import 'package:flutter_watch_shop_app/shared/custom_text.dart';
import 'package:flutter_watch_shop_app/shared/model/order_list_detail.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';
import 'package:flutter_watch_shop_app/shared/widget/bloc_listener.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatelessWidget {
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
        title: Text('Order detail'),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      body: Body(orderId),
    );
  }
}

class Body extends StatefulWidget {


  final String orderId;

  Body(this.orderId);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  handleEvent(BaseEvent event) {
    if (event is ShouldPopEvent) {
      Navigator.pushReplacementNamed(context, '/order');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OrderDetailBloc(
        orderRepo: Provider.of(context),
      ),
      child: Consumer<OrderDetailBloc>(
        builder: (context, bloc, child) => BlocListener<OrderDetailBloc>(
          listener: handleEvent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(9.0),
                child: Row(
                  children: <Widget>[
                    CustomText(
                      text: 'Mã đơn hàng : ',
                      weight: FontWeight.w400,
                      color: Colors.black,
                      size: 14,
                    ),
                    CustomText(
                      text: widget.orderId,
                      size: 14,
                      weight: FontWeight.bold,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(
                      text: 'Sản phẩm :',
                      size: 14,
                      weight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              OrderDetailInfo(bloc),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderDetailInfo extends StatefulWidget {
  final OrderDetailBloc bloc;

  OrderDetailInfo(this.bloc);

  @override
  _OrderDetailInfoState createState() => _OrderDetailInfoState();
}

class _OrderDetailInfoState extends State<OrderDetailInfo> {
  @override
  void initState() {
    super.initState();
    widget.bloc.getOrderDetailForOrderList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Object>.value(
      value: widget.bloc.orderDetailStream,
      initialData: null,
      catchError: (context, err) {
        return err;
      },
      child: Consumer<Object>(
        builder: (context, data, child) {
          if (data == null) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.black38,
              ),
            );
          }

          if (data is RestError) {
            return Center(
                child: Container(
              child: Text(data.message),
            ));
          }

          if (data is OrderListDetail) {
            return Expanded(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ProductListWidget(data.items),
                  ),
                  Consumer<OrderDetailBloc>(
                    builder: (context, bloc, child)
                    => InkWell(
                      onTap: () {
                        bloc.event.add(DestroyOrderEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomText(
                              text: 'Hủy đơn hàng',
                              color: Colors.red,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: 'Tổng tiền : ${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                        symbol: '\$',
                        fractionDigits: 0,
                        ), amount: data.total).output.symbolOnRight}',
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return Container();
        },
      ),
    );
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
    var bloc = Provider.of<OrderDetailBloc>(context);
    widget.productList.sort((p1, p2) => p1.price.compareTo(p2.price));
    return ListView.builder(
      itemCount: widget.productList.length,
      itemBuilder: (context, index) =>
          _buildRow(widget.productList[index], bloc),
    );
  }

  Widget _buildRow(Product product, OrderDetailBloc bloc) {
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
                  Text(
                    'Số lượng: ' + product.quantity.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.0,
                        height: 1.2,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
