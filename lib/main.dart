import 'package:flutter/material.dart';
import 'package:flutter_watch_shop_app/module/cate/category_page.dart';
import 'package:flutter_watch_shop_app/module/checkout/checkout_page.dart';
import 'package:flutter_watch_shop_app/module/order_detail/order_detail_page.dart';
import 'package:flutter_watch_shop_app/module/order_list/order_list_page.dart';
import 'package:flutter_watch_shop_app/module/product_detail/product_detail_page.dart';
import 'package:flutter_watch_shop_app/module/search/search_page.dart';
import 'package:flutter_watch_shop_app/module/signin/signin_page.dart';
import 'package:flutter_watch_shop_app/module/splash/splash.dart';
import 'module/home/home_page.dart';
import 'module/signup/signup_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFE2E1E1),
      ),
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/' : (context) => SplashPage(),
        '/home' : (context) => HomePage(),
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/detail' : (context) => DetailPage(),
        '/checkout': (context) => CheckoutPage(),
        '/search': (context) => SearchPage(),
        '/order' : (context) => OrderListPage(),
        '/order-detail' : (context) => OrderDetailPage(),
        '/cate' : (context) => CatePage(),
      }
    );
  }
}
