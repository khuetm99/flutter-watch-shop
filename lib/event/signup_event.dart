import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';


class SignUpEvent extends BaseEvent {
  String fullName;
  String phone;
  String email;
  String pass;

  SignUpEvent({
    @required this.fullName,
    @required this.phone,
    @required this.email,
    @required this.pass,
  });
}
