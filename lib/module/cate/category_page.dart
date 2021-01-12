import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_watch_shop_app/base/base_widget.dart';
import 'package:flutter_watch_shop_app/data/remote/product_service.dart';
import 'package:flutter_watch_shop_app/data/repo/product_repo.dart';
import 'package:flutter_watch_shop_app/module/cate/category_bloc.dart';
import 'package:flutter_watch_shop_app/shared/model/category.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';
import 'package:provider/provider.dart';

class CatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Category category = ModalRoute.of(context).settings.arguments;
    return PageContainer(
      di: [
        Provider.value(value: ProductService()),
        ProxyProvider<ProductService, ProductRepo>(
            update: (context, productService, previous) =>
                ProductRepo(productService: productService))
      ],
      bloc: [],
      body: Column(children: [
        Container(
          height: 280,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(category.cateImage),
                fit: BoxFit.fill),
          ),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                gradient:
                    LinearGradient(begin: Alignment.bottomRight, colors: [
              Colors.black.withOpacity(.6),
              Colors.black.withOpacity(.1),
            ])),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
        CateList(category: category,)
      ]),
    );
  }
}

class CateList extends StatelessWidget {
  final Category category;

  CateList({this.category});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: CateBloc(productRepo: Provider.of(context)),
      child: Consumer<CateBloc>(
        builder: (context, bloc, child) => Container(
          child: StreamProvider<Object>.value(
            value: bloc.getProductByCate(category.cateId),
            initialData: null,
            catchError: (context, error) {
              return error;
            },
            child: Consumer<Object>(builder: (context, data, child) {
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
              var products = data as List<Product>;
              return Expanded(
                child: GridView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2.0,
                      child: MaterialButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/detail', arguments: products[index]),
                        child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                  height: 180,
                                  child: Image.network(products[index].productImage, fit: BoxFit.fill)),
                              SizedBox(height: 10.0),
                              Text(
                                products[index].productName.length > 15
                                    ? products[index].productName.toUpperCase().substring(0, 14)
                                    : products[index].productName.toUpperCase(),
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
                                products[index].cateName.toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12.0, fontFamily: 'Muli', color: Colors.grey),
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                '${FlutterMoneyFormatter(settings: MoneyFormatterSettings(
                                  symbol: '\$',
                                  fractionDigits: 0,
                                ), amount: products[index].price).output.symbolOnRight}',
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
                  },
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 5.0,
                    mainAxisSpacing: 5.0,
                    childAspectRatio: 0.6,
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
  Widget productCard(BuildContext context, CateBloc bloc, Product product) {
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
