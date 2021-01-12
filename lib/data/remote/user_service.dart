import 'package:dio/dio.dart';
import 'package:flutter_watch_shop_app/network/watch_client.dart';

class UserService {
  Future<Response> signIn(String email, String pass) {
    return WatchClient.instance.dio.post('/user/sign-in',
    data: {
      'email' : email,
      'password' : pass,
    });
  }

  Future<Response> signUp(String fullName, String phone, String email, String pass) {
    return WatchClient.instance.dio.post(
      '/user/sign-up',
      data: {
        'fullName': fullName,
        'phone': phone,
        'email' : email,
        'password': pass,
      },
    );
  }

  Future<Response> getProfile() {
    return WatchClient.instance.dio.get(
      '/user/profile',
      );
  }
}