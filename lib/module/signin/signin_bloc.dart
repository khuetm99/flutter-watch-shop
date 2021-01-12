import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/user_repo.dart';
import 'package:flutter_watch_shop_app/event/signin_event.dart';
import 'package:flutter_watch_shop_app/event/signin_fail_event.dart';
import 'package:flutter_watch_shop_app/event/signin_sucess_event.dart';
import 'package:flutter_watch_shop_app/shared/validation.dart';
import 'package:rxdart/rxdart.dart';

class SignInBloc extends BaseBloc with ChangeNotifier {
  final _emailSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  UserRepo _userRepo;

  SignInBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  }

  Stream<String> get emailStream => _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passStream => _passSubject.stream.transform(passValidation);
  Sink<String> get passSink => _passSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  var emailValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (Validation.isEmailValid(email)) {
      sink.add(null);
      return;
    }
    sink.add('Email invalid');
  });

  var passValidation =
      StreamTransformer<String, String>.fromHandlers(handleData: (pass, sink) {
    if (Validation.isPassValid(pass)) {
      sink.add(null);
      return;
    }
    sink.add('Password too short');
  });

  validateForm() {
    Observable.combineLatest2(
      _emailSubject,
      _passSubject,
      (email, pass) {
        return Validation.isEmailValid(email) && Validation.isPassValid(pass);
      },
    ).listen((enable) {
      btnSink.add(enable);
    });
  }

  @override
  void dispatchEvent(BaseEvent event) {
    switch (event.runtimeType) {
      case SignInEvent:
        handleSignIn(event);
        break;
    }
  }

  handleSignIn(event) {
    btnSink.add(false); //Khi bắt đầu call api thì disable nút sign-in
    loadingSink.add(true); // show loading

    Future.delayed(Duration(seconds: 3), () {
      SignInEvent e = event as SignInEvent;
      _userRepo.signIn(e.email, e.pass).then(
              (userData) {
            processEventSink.add(SignInSuccessEvent(userData));
          },
          onError: (e) {
            print(e);
            btnSink.add(true); //Khi có kết quả thì enable nút sign-in trở lại
            loadingSink.add(false); // hide loading
            processEventSink
                .add(SignInFailEvent(e.toString())); // thông báo kết quả
          },
      );
    });
  }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }
}
