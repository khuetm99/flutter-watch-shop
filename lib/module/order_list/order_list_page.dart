import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_watch_shop_app/base/base_widget.dart';
import 'package:flutter_watch_shop_app/data/remote/order_service.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/module/order_list/order_list_bloc.dart';
import 'package:flutter_watch_shop_app/shared/model/order_detail.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';
import 'package:provider/provider.dart';

class OrderListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      di: [
        Provider.value(
          value: OrderService(),
        ),
        ProxyProvider<OrderService, OrderRepo>(
          update: (context, orderService, previous) =>
              OrderRepo(
                orderService: orderService,
              ),
        )
      ],
      bloc: [],
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text("Orders"),
        leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: OrderListBloc(
        orderRepo : Provider.of(context)
      ),
      child: Consumer<OrderListBloc>(
        builder: (context, bloc, child)
        => Container(
          child: StreamProvider<Object>.value(
            value: bloc.getOrderList(),
            initialData: null,
            catchError: (context, error) {
              return error;
            },
            child: Consumer<Object>(
              builder: (context, data, child){
               if (data == null) {
                 return Center(
                   child: CircularProgressIndicator(
                     backgroundColor: Colors.yellow,
                   ),
                 );
               }

               if (data is RestError) {
                 return Center(
                   child: Container(
                     child: Text(
                       data.message,
                       style: TextStyle(fontSize: 20),
                     ),
                   ),
                 );
               }
                  var orders = data as List<OrderDetail>;
               return  ListView.builder(
                  itemCount: orders.length ,
                  itemBuilder: (context , index){
                     return GestureDetector(
                       onTap: () {
                         Navigator.pushNamed(context, '/order-detail',arguments: orders[index].orderId);
                       },
                       child: Container(
                         height: 100,
                         child: Card(
                           child: ListTile(
                             leading: Text(
                               '${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                                 symbol: '\$',
                                 fractionDigits: 0,
                               ), amount: orders[index].total).output.symbolOnRight}',
                               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black),
                             ),
                             title: Text( 'Đơn hàng của ' + orders[index].userName, style: TextStyle(fontSize: 19),),
                             subtitle: Text(DateTime.parse(orders[index].createdAt).toString()),
                             trailing: Text(orders[index].status, style: TextStyle(fontSize: 16, color: Colors.green), ),
                           ),
                         ),
                       ),
                     );
                  });
             }
            ),
          ),
        ),
      ),
    );
  }
}

