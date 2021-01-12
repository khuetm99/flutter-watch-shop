import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/base/base_widget.dart';
import 'package:flutter_watch_shop_app/data/remote/user_service.dart';
import 'package:flutter_watch_shop_app/data/repo/user_repo.dart';
import 'package:flutter_watch_shop_app/event/signin_event.dart';
import 'package:flutter_watch_shop_app/event/signin_fail_event.dart';
import 'package:flutter_watch_shop_app/event/signin_sucess_event.dart';
import 'package:flutter_watch_shop_app/module/signin/signin_bloc.dart';
import 'package:flutter_watch_shop_app/shared/widget/bloc_listener.dart';
import 'package:flutter_watch_shop_app/shared/widget/loading_task.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PageContainer(
      di: [
        Provider.value(value: UserService()),
        ProxyProvider<UserService, UserRepo>(
            update: (context, userService, previous) =>
                UserRepo(userService: userService))
      ],
      bloc: [],
      body: SignInFormWidget(),
    );
  }
}

class SignInFormWidget extends StatefulWidget {
  @override
  _SignInFormWidgetState createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  final TextEditingController _txtEmailController = TextEditingController();
  final TextEditingController _txtPassController = TextEditingController();

  handleEvent(BaseEvent event) {
    if (event is SignInSuccessEvent) {
      Navigator.pushReplacementNamed(context, '/home');
      return;
    }

    if (event is SignInFailEvent) {
      final snackBar = SnackBar(
        content: Text(event.errMessage),
        backgroundColor: Colors.red,
      );
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignInBloc(userRepo: Provider.of(context)),
      child: Consumer<SignInBloc>(
        builder: (context, bloc, child) => BlocListener<SignInBloc>(
          listener: handleEvent,
          child: LoadingTask(
            bloc: bloc,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/watch1.jpg"),
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "SIGN IN",
                              style: Theme.of(context).textTheme.display1,
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/sign-up');
                              },
                              child: Text(
                                "SIGN UP",
                                style: Theme.of(context).textTheme.button,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 40),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.alternate_email,
                                  color: Color(0xFFFFBD73),
                                ),
                              ),
                              Expanded(
                                child: _buildEmailField(bloc),
                              )
                            ],
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.lock,
                                color: Color(0xFFFFBD73),
                              ),
                            ),
                            Expanded(
                              child: _buildPasswordField(bloc),
                            ),
                          ],
                        ),
                        Spacer(),
                        _buildSignInButton(bloc),
                        SizedBox(
                          height: 5,
                        )
                      ]),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton(SignInBloc bloc) {
    return StreamProvider<bool>.value(
      initialData: false,
      value: bloc.btnStream,
      child: Consumer<bool>(
        builder: (context, enable, child) => Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: 60,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 143, 158, 1),
                    Color.fromRGBO(255, 188, 143, 1),
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
              onPressed: enable
                  ? () {
                      bloc.event.add(SignInEvent(
                          email: _txtEmailController.text,
                          pass: _txtPassController.text));
                    }
                  : null,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Center(
                child: Text(
                  'Đăng nhập',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Netflix",
                    fontWeight: FontWeight.w600,
                    fontSize: 23,
                    letterSpacing: 0.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.emailStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextField(
          onChanged: (text) {
            bloc.emailSink.add(text);
          },
          controller: _txtEmailController,
          cursorColor: Colors.black,
          decoration: InputDecoration(
              hintText: "a@gmail.com", labelText: "Email", errorText: msg),
        ),
      ),
    );
  }

  Widget _buildPasswordField(SignInBloc bloc) {
    return StreamProvider<String>.value(
      initialData: null,
      value: bloc.passStream,
      child: Consumer<String>(
        builder: (context, msg, child) => TextField(
          onChanged: (text) {
            bloc.passSink.add(text);
          },
          controller: _txtPassController,
          cursorColor: Colors.black,
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Password",
            labelText: "Password",
            errorText: msg,
          ),
        ),
      ),
    );
  }
}
