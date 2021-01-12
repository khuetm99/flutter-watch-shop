import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_watch_shop_app/base/base_widget.dart';
import 'package:flutter_watch_shop_app/data/remote/order_service.dart';
import 'package:flutter_watch_shop_app/data/remote/product_service.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/data/repo/product_repo.dart';
import 'package:flutter_watch_shop_app/event/add_to_cart_event.dart';
import 'package:flutter_watch_shop_app/module/product_detail/product_detail_bloc.dart';
import 'package:flutter_watch_shop_app/shared/color.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';
import 'package:flutter_watch_shop_app/shared/model/shopping_cart.dart';
import 'package:provider/provider.dart';
import 'package:simple_html_css/simple_html_css.dart';

class DetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Product product = ModalRoute.of(context).settings.arguments;
    return PageContainer(
      di: [
        Provider.value(
          value: ProductService(),
        ),
        Provider.value(
          value: OrderService(),
        ),
        ProxyProvider<ProductService, ProductRepo>(
          update: (context, productService, previous) =>
              ProductRepo(productService: productService),
        ),
        ProxyProvider<OrderService, OrderRepo>(
          update: (context, orderService, previous) =>
              OrderRepo(orderService: orderService),
        ),
      ],
      bloc: [],
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: AppColors.kPrimaryColor,),
            onPressed: () {
              Navigator.pushNamed(context, '/home');;
            }),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/search');
                },
                icon : Icon(Icons.search, color: AppColors.kPrimaryColor, size: 25)),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
                margin: EdgeInsets.only(right: 5),
                child: ShoppingCartWidget()),
          ),
        ],
      ),
      body: Body(product:product),
    );
  }
}


class ShoppingCartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ProductDetailBloc.getInstance(
        productRepo: Provider.of(context),
        orderRepo: Provider.of(context),
      ),
      child: CartWidget(),
    );
  }
}

class CartWidget extends StatefulWidget {
  @override
  _CartWidgetState createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var bloc = Provider.of<ProductDetailBloc>(context);
    bloc.getShoppingCartInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductDetailBloc>(
      builder: (context, bloc, child) => StreamProvider<Object>.value(
        value: bloc.shoppingCartStream,
        initialData: null,
        catchError: (context, error) {
          return error;
        },
        child: Consumer<Object>(
          builder: (context, data, child) {
            if (data == null || data is RestError) {
              return Icon(Icons.shopping_cart, color: AppColors.kPrimaryColor,);
            }

            var cart = data as ShoppingCart;
            return GestureDetector(
              onTap: () {
                if (data == null) {
                  return;
                }
                Navigator.pushNamed(context, '/checkout',
                    arguments: cart.orderId);
              },
              child: Badge(
                badgeContent: Text(
                  '${cart.total}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Icon(Icons.shopping_cart, color: AppColors.kPrimaryColor),
              ),
            );
          },
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  final Product product;
  Body({this.product});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  static Color white = Colors.white;
  static Color kPrimaryColor = Color.fromRGBO(56, 72, 129, 1);

  Size ds = Size(0.0, 0.0);

  double getWidth(double myWidth) {
    return (myWidth / 411.43) * MediaQuery.of(context).size.width;
  }

  double getHeight(double myHeight) {
    return (myHeight / 774.86) * MediaQuery.of(context).size.height;
  }

  TextStyle style(Color color, double size, bool isBold) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontFamily: 'Muli',
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
  }
  Color btnColor = kPrimaryColor;
  Color btnTextColor = white;

  // ------------- USING --------------

  Widget smallContainer(String title, String text) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: style(Colors.grey[500], 15, true)),
          SizedBox(height: getHeight(5)),
          Text(text, style: style(kPrimaryColor, 18, true)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: ProductDetailBloc.getInstance(
          productRepo: Provider.of(context),
          orderRepo: Provider.of(context)),
      child: Consumer<ProductDetailBloc>(
        builder: (context , bloc ,child)
        => ListView(
          children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                  left: getWidth(20),
                  right: getWidth(30),
                  top: getHeight(10),
                  bottom: getHeight(10),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: getWidth(20), bottom: getHeight(10)),
                child: Row(
                  children: <Widget>[
                    Text('SPECIAL',
                        style: style(Colors.grey[500], 12, true)
                            .copyWith(letterSpacing: 7)),
                    SizedBox(width: getWidth(20)),
                    Container(
                      width: 60,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(.4),
                        borderRadius: BorderRadius.circular(getHeight(2)),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: EdgeInsets.only(left: getWidth(20), bottom: getHeight(50)),
                child: Text(widget.product.productName,
                    style: style(kPrimaryColor, 28, false)),
              ),
              Container(
                margin: EdgeInsets.only(left: getWidth(40), right: getWidth(40)),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 200,
                        child: Hero(
                          tag: widget.product.productId,
                          child: Image.network(widget.product.productImage,
                              fit: BoxFit.fill),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: getHeight(200),
                        margin: EdgeInsets.only(left: getWidth(60)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            smallContainer(
                              'GIÁ', '' + '${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                              symbol: '\$',
                              fractionDigits: 0,
                            ), amount: widget.product.price).output.symbolOnRight}',),
                            smallContainer(
                                'SỐ LƯỢNG', '' + widget.product.quantity.toString()),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: HTML.toTextSpan(
                          context,
                            widget.product.description,
                          defaultTextStyle:  style(
                             Colors.grey[800],
                             14,
                             false
                          ),
                          overrideStyle: {
                          "p": TextStyle(fontSize: 16),
                          "a": TextStyle(wordSpacing: 1.5),}
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(255, 143, 158, 1),
                          Color.fromRGBO(255, 188, 143, 1),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(25.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.2),
                          spreadRadius: 4,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: FlatButton(
                    onPressed: () {
                      bloc.event.add(AddToCartEvent(widget.product));
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Thêm vào giỏ hàng',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Netflix",
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                              letterSpacing: 0.0,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10,),
                          Icon(
                            Icons.add_shopping_cart,
                            color: kPrimaryColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
