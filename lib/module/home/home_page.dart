import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_watch_shop_app/base/base_widget.dart';
import 'package:flutter_watch_shop_app/data/remote/cate_service.dart';
import 'package:flutter_watch_shop_app/data/remote/order_service.dart';
import 'package:flutter_watch_shop_app/data/remote/product_service.dart';
import 'package:flutter_watch_shop_app/data/remote/user_service.dart';
import 'package:flutter_watch_shop_app/data/repo/cate_repo.dart';
import 'package:flutter_watch_shop_app/data/repo/order_repo.dart';
import 'package:flutter_watch_shop_app/data/repo/product_repo.dart';
import 'package:flutter_watch_shop_app/data/repo/user_repo.dart';
import 'package:flutter_watch_shop_app/data/spref/spref.dart';
import 'package:flutter_watch_shop_app/event/add_to_cart_event.dart';
import 'package:flutter_watch_shop_app/module/home/home_bloc.dart';
import 'package:flutter_watch_shop_app/shared/color.dart';
import 'package:flutter_watch_shop_app/shared/custom_text.dart';
import 'package:flutter_watch_shop_app/shared/model/category.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';
import 'package:flutter_watch_shop_app/shared/model/shopping_cart.dart';
import 'package:flutter_watch_shop_app/shared/model/user_data.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
        di: [
          Provider.value(
            value: ProductService(),
          ),
          Provider.value(
            value: OrderService(),
          ),
          Provider.value(
            value: CateService(),
          ),
          Provider.value(
            value: UserService(),
          ),
          ProxyProvider<ProductService, ProductRepo>(
            update: (context, productService, previous) =>
                ProductRepo(productService: productService),
          ),
          ProxyProvider<OrderService, OrderRepo>(
            update: (context, orderService, previous) =>
                OrderRepo(orderService: orderService),
          ),
          ProxyProvider<CateService, CateRepo>(
            update: (context, cateService, previous) =>
                CateRepo(cateService: cateService),
          ),
          ProxyProvider<UserService, UserRepo>(
            update: (context, userService, previous) =>
                UserRepo(userService: userService),
          ),
        ],
        bloc: [],
        appBar: AppBar(
          title: CustomText(text :'KTW', size: 20,),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all( 10.0),
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/search');
                },
              ),
            ),
            ShoppingCartWidget(),
          ],
        ),
        drawer: DrawerCustom(),
        body: Body());
  }
}

class DrawerCustom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeBloc(
        productRepo: Provider.of(context),
        orderRepo: Provider.of(context),
        cateRepo: Provider.of(context),
        userRepo: Provider.of(context),
      ),
      child: Consumer<HomeBloc>(
        builder: (context, bloc, child)
        => StreamProvider<Object>.value(
          value: bloc.getUserProfile(),
          initialData: null,
          catchError: (context, error) {
            return error;
          },
          child: Consumer<Object>(
            builder: (context, data, child) {
              var user = data as UserData;
              return Drawer(
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(color: AppColors.primaryColor),
                    accountName: CustomText(
                      text: user?.fullName ?? "username lading...",
                      color: Colors.white,
                      weight: FontWeight.bold,
                      size: 18,
                    ),
                    accountEmail: CustomText(
                      text: user?.email ?? "email loading...",
                      color: Colors.white,
                    ),
                  ),
                  ListTile(
                    onTap: () {
                    },
                    leading: Icon(Icons.home),
                    title: CustomText(text: "Home"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushNamed(context, '/order');
                    },
                    leading: Icon(Icons.bookmark_border),
                    title: CustomText(text: "My orders"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/sign-in');
                    },
                    leading: Icon(Icons.exit_to_app),
                    title: CustomText(text: "Log out"),
                  ),
                ],
              ),
            );}
          ),
        ),
      ),
    );
  }
}


class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  Color white = Colors.white;
  Color kPrimaryColor = Color.fromRGBO(56, 72, 129, 1);
  Color lightGrey = Colors.grey[400];

  TextStyle style(Color color, double size, bool isBold) {
    return TextStyle(
      color: color,
      fontSize: size,
      fontFamily: 'Muli',
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20.0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Danh mục',
                        style: style(kPrimaryColor, 20, false),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 20),
          CateListWidget(),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5,0,5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomText(text: 'Sản phẩm', size: 20, color: AppColors.kPrimaryColor,),
              ],
            ),
          ),
          ProductListWidget(),
        ],
      ),
    );
  }
}

class ShoppingCartWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeBloc(
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

    var bloc = Provider.of<HomeBloc>(context);
    bloc.getShoppingCartInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBloc>(
      builder: (context, bloc, child) => StreamProvider<Object>.value(
        value: bloc.shoppingCartStream,
        initialData: null,
        catchError: (context, error) {
          return error;
        },
        child: Consumer<Object>(
          builder: (context, data, child) {
            if (data == null || data is RestError) {
              return Container(
                margin: EdgeInsets.only(top: 10, right: 10, bottom: 5),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.black,
                ),
              );
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
              child: Container(
                margin: EdgeInsets.only(top: 15, right: 20, bottom: 10),
                child: Badge(
                  badgeContent: Text(
                    '${cart.total}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CateListWidget extends StatefulWidget {
  @override
  _CateListWidgetState createState() => _CateListWidgetState();
}

class _CateListWidgetState extends State<CateListWidget> {
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeBloc(
          productRepo: Provider.of(context),
          orderRepo: Provider.of(context),
          cateRepo: Provider.of(context)),
      child: Consumer<HomeBloc>(
          builder: (context, bloc, child) => StreamProvider<Object>.value(
                value: bloc.getCateList(),
                initialData: null,
                catchError: (context, error) {
                  return error;
                },
                child: Consumer<Object>(
                  builder: (context, data, child) {
                    if (data == null) {
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.black12,
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
                    var cates = data as List<Category>;
                    return ConstrainedBox(
                      constraints:
                          BoxConstraints(maxHeight: 220, minHeight: 60.0),
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: cates.length,
                          itemBuilder: (context, index) {
                            return Container(
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, '/cate', arguments: cates[index]);
                                    },
                                    child: CategoryCard(cates[index].cateImage,
                                        cates[index].cateName)));
                          }),
                    );
                  },
                ),
              )),
    );
  }

  Widget CategoryCard(String image, String name) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(bottom: getHeight(40)),
      child: Stack(
        children: <Widget>[
          Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(image, fit: BoxFit.fill),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(name,
                        style: style(AppColors.kPrimaryColor, 13, true)
                            .copyWith(letterSpacing: 5)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: HomeBloc(
        productRepo: Provider.of(context),
        orderRepo: Provider.of(context),
        cateRepo: Provider.of(context),
      ),
      child: Consumer<HomeBloc>(
        builder: (context, bloc, child) => Container(
          child: StreamProvider<Object>.value(
            value: bloc.getProductList(),
            initialData: null,
            catchError: (context, error) {
              return error;
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
                      child: Text(
                        data.message,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  );
                }
                var products = data as List<Product>;
                return Expanded(
                  child: GridView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return productCard(context, bloc, products[index]);
                    },
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5.0,
                      mainAxisSpacing: 5.0,
                      childAspectRatio: 0.6,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget productCard(BuildContext context, HomeBloc bloc, Product product) {
    return Card(
      elevation: 2.0,
      child: MaterialButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        onPressed: () =>
            Navigator.pushNamed(context, '/detail', arguments: product),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  height: 180,
                  child: Image.network(product.productImage, fit: BoxFit.fill)),
              SizedBox(height: 10.0),
              Text(
                product.productName.length > 15
                    ? product.productName.toUpperCase().substring(0, 14)
                    : product.productName.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Color.fromRGBO(56, 72, 129, 1),
                  fontFamily: 'Muli',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.0),
              Text(
                product.cateName.toUpperCase(),
                style: TextStyle(
                    fontSize: 12.0, fontFamily: 'Muli', color: Colors.grey),
              ),
              SizedBox(height: 8.0),
              Text(
                '${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                      symbol: '\$',
                      fractionDigits: 0,
                    ), amount: product.price).output.symbolOnRight}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
