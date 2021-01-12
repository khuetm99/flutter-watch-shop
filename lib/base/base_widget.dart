import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class PageContainer extends StatelessWidget {
  final PreferredSizeWidget appBar;
  final Widget body;
  final Widget drawer;

  final List<SingleChildWidget> bloc;
  final List<SingleChildWidget> di;



  PageContainer({this.appBar, this.bloc, this.di, this.body, this.drawer});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...di,
        ...bloc,
      ],
      child: Scaffold(
        appBar: appBar,
        drawer: drawer,
        body: body,
      ),
    );
  }
}

class NavigatorProvider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[],
      ),
    );
  }
}
