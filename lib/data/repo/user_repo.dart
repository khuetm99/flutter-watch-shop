import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_watch_shop_app/data/remote/user_service.dart';
import 'package:flutter_watch_shop_app/data/spref/spref.dart';
import 'package:flutter_watch_shop_app/shared/constant.dart';
import 'package:flutter_watch_shop_app/shared/model/rest_error.dart';
import 'package:flutter_watch_shop_app/shared/model/user_data.dart';

class UserRepo {
  UserService _userService;

  UserRepo({@required UserService userService}) : _userService = userService;

  Future<UserData> signIn(String email, String pass) async {
    var c = Completer<UserData>();
    try {
      var response = await _userService.signIn(email, pass);
      var userData = UserData.fromJson(response.data['data']);
      if (userData != null) {
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
        c.complete(userData);
      }
    } on DioError catch (e) {
      print(e.response.data);
      c.completeError('Đăng nhập thất bại');
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<UserData> signUp(
      String fullName, String phone, String email, String pass) async {
    var c = Completer<UserData>();
    try {
      var response = await _userService.signUp(fullName, phone, email, pass);
      var userData = UserData.fromJson(response.data['data']);
      if (userData != null) {
        SPref.instance.set(SPrefCache.KEY_TOKEN, userData.token);
        c.complete(userData);
      }
    } on DioError {
      c.completeError('Đăng ký thất bại');
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

  Future<UserData> getProfile() async{
    var c = Completer<UserData>();
    try{
      var response = await _userService.getProfile();
      var user = UserData.fromJson(response.data['data']);
      c.complete(user);
    } on DioError {
      c.completeError(RestError.fromData('Lỗi lấy thông tin user'));
    } catch (e) {
      c.completeError(e);
    }
    return c.future;
  }

}
