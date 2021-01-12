import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_watch_shop_app/data/remote/cate_service.dart';
import 'package:flutter_watch_shop_app/shared/model/category.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';

class CateRepo {
  CateService _cateService;

  CateRepo({@required CateService cateService})
      : _cateService = cateService;

  Future<List<Category>> getCategoryList() async {
    var c = Completer<List<Category>>();
    try {
      var response = await _cateService.getCateList();
      var cateList = Category.parseCategoryList(response.data);
      c.complete(cateList);
    } on DioError {
      c.completeError(RestError.fromData('Không có dữ liệu'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

}