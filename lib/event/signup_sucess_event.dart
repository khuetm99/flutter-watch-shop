import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/shared/model/user_data.dart';

class SignUpSuccessEvent extends BaseEvent {
  final UserData userData;
  SignUpSuccessEvent(this.userData);
}
