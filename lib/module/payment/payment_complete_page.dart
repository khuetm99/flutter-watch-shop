import 'package:flutter/material.dart';
import 'package:flutter_watch_shop_app/shared/custom_text.dart';

class PaymentCompletePage extends StatefulWidget {
  @override
  _PaymentCompletePageState createState() => _PaymentCompletePageState();
}

class _PaymentCompletePageState extends State<PaymentCompletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 150,
                      ),
                    ),
                    SizedBox(height: 45,),
                    Center(
                      child: Text(
                        'Cảm ơn bạn đã mua sản phẩm !',
                        style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w400,
                            color: Colors.green,
                          fontFamily: 'Muli'
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFF26A69A),
                                Color(0xFF4DB6AC),
                                Color(0xFF80CBC4),
                              ],
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                CustomText(
                                  text: "Tiếp tục mua hàng",
                                  color: Colors.white,
                                  size: 22,
                                  weight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])),
        ));
  }
}