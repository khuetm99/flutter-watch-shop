import 'package:flutter/material.dart';
import 'package:flutter_watch_shop_app/shared/style/button_style.dart';


class NormalButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  NormalButton({@required this.onPressed, @required this.title});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 200,
      height: 45,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 188, 143, 1),
                Color.fromRGBO(255, 143, 158, 1),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(25.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.withOpacity(0.2),
                spreadRadius: 4,
                blurRadius: 10,
                offset: Offset(0, 3),
              )
            ]),
        child: FlatButton(
          onPressed: onPressed,
          // color: Colors.red[200],
          // disabledColor: Colors.yellow[500],
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(4.0)),
          child: Text(
            title,
            style: BtnStyle.normal(),
          ),
        ),
      ),
    );
  }
}
