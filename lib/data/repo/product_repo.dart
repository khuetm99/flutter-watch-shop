import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/data/remote/product_service.dart';
import 'package:flutter_watch_shop_app/shared/model/product.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';

class ProductRepo {
  ProductService _productService;

  ProductRepo({@required ProductService productService})
      : _productService = productService;

  Future<List<Product>> getProductList() async {
    var c = Completer<List<Product>>();
    try {
      var response = await _productService.getProductList();
      var productList = Product.parseProductList(response.data);
      c.complete(productList);
    } on DioError {
      c.completeError(RestError.fromData('Không có dữ liệu'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<List<Product>> getProductListByCateId(String cateId) async {
    var c = Completer<List<Product>>();
    try {
      var response = await _productService.getProductListByCate(cateId);
      var productList = Product.parseProductList(response.data);
      c.complete(productList);
    } on DioError {
      c.completeError(RestError.fromData('Không có dữ liệu'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<List<Product>> getProductListByName(String name) async {
    var c = Completer<List<Product>>();
    try {
      var response = await _productService.getProductListByName(name);
      var productList = Product.parseProductList(response.data);
      c.complete(productList);
    } on DioError {
      c.completeError(RestError.fromData('Không có dữ liệu'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }
}
