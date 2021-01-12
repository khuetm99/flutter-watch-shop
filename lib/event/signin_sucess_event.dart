import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/shared/model/user_data.dart';

class SignInSuccessEvent extends BaseEvent {
  final UserData userData;
  SignInSuccessEvent(this.userData);
}
