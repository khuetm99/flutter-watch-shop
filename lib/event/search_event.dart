import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';

class SearchEvent extends BaseEvent {
  String productName;

  SearchEvent({
    @required this.productName,
  });
}
