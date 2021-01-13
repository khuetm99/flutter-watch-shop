import 'package:flutter/material.dart';
import 'package:flutter_money_formatter/flutter_money_formatter.dart';
import 'package:flutter_watch_shop_app/base/base_widget.dart';
import 'package:flutter_watch_shop_app/data/remote/product_service.dart';
import 'package:flutter_watch_shop_app/data/repo/product_repo.dart';
import 'package:flutter_watch_shop_app/event/search_event.dart';
import 'package:flutter_watch_shop_app/module/search/search_bloc.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      di: [
        Provider.value(
          value: ProductService(),
        ),
        ProxyProvider<ProductService, ProductRepo>(
          update: (context, productService, previous) =>
              ProductRepo(productService: productService),
        ),
      ],
      bloc: [],
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.black,)
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Search Page'),
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
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: SearchBloc(productRepo: Provider.of(context)),
      child: Consumer<SearchBloc>(
        builder: (context, bloc, child) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  onChanged: (text) {
                    bloc.event.add(SearchEvent(productName: text));
                  },
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: "Tìm kiếm sản phẩm",
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        searchController.clear();
                      },
                      child: Icon(
                        Icons.clear,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child: StreamProvider<Object>.value(
                value: bloc.searchStream,
                initialData: null,
                catchError: (context, error) {
                  return error;
                },
                child: Consumer<Object>(
                  builder: (context, data, child) {
                    if (data == null) {
                      return Container();
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
                     debugPrint(products.toString());
                    return Expanded(
                      child: GridView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          return productCard(context, products[index]);
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
          ],
        ),
      ),
    );
  }

  Widget productCard(BuildContext context, Product product) {
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
