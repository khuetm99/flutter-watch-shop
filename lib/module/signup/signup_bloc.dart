import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_watch_shop_app/base/base_bloc.dart';
import 'package:flutter_watch_shop_app/base/base_event.dart';
import 'package:flutter_watch_shop_app/data/repo/user_repo.dart';
import 'package:flutter_watch_shop_app/event/signup_event.dart';
import 'package:flutter_watch_shop_app/event/signup_fail_event.dart';
import 'package:flutter_watch_shop_app/event/signup_sucess_event.dart';
import 'package:flutter_watch_shop_app/shared/validation.dart';
import 'package:rxdart/rxdart.dart';

class SignUpBloc extends BaseBloc with ChangeNotifier {
  final _nameSubject = BehaviorSubject<String>();
  final _phoneSubject = BehaviorSubject<String>();
  final _emailSubject = BehaviorSubject<String>();
  final _passSubject = BehaviorSubject<String>();
  final _btnSubject = BehaviorSubject<bool>();

  UserRepo _userRepo;

  SignUpBloc({@required UserRepo userRepo}) {
    _userRepo = userRepo;
    validateForm();
  }

  Stream<String> get nameStream => _nameSubject.stream.transform(nameValidation);
  Sink<String> get nameSink => _nameSubject.sink;

  Stream<String> get phoneStream => _phoneSubject.stream.transform(phoneValidation);
  Sink<String> get phoneSink => _phoneSubject.sink;

  Stream<String> get emailStream => _emailSubject.stream.transform(emailValidation);
  Sink<String> get emailSink => _emailSubject.sink;

  Stream<String> get passStream => _passSubject.stream.transform(passValidation);
  Sink<String> get passSink => _passSubject.sink;

  Stream<bool> get btnStream => _btnSubject.stream;
  Sink<bool> get btnSink => _btnSubject.sink;

  var nameValidation =
  StreamTransformer<String, String>.fromHandlers(handleData: (name, sink) {
    if (Validation.isDisplayNameValid(name)) {
      sink.add(null);
      return;
    }
    sink.add('Name too short');
  });

  var phoneValidation =
  StreamTransformer<String, String>.fromHandlers(handleData: (phone, sink) {
    if (Validation.isPhoneValid(phone)) {
      sink.add(null);
      return;
    }
    sink.add('Phone invalid');
  });

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
      case SignUpEvent:
        handleSignUp(event);
        break;
    }
  }

  handleSignUp(event) {
    btnSink.add(false);
    loadingSink.add(true); // show loading

    Future.delayed(Duration(seconds: 3), () {
      SignUpEvent e = event as SignUpEvent;
      _userRepo.signUp(e.fullName, e.phone, e.email, e.pass).then(
              (userData) {
            processEventSink.add(SignUpSuccessEvent(userData));
          },
          onError: (e) {
            btnSink.add(true);
            loadingSink.add(false);
            processEventSink.add(SignUpFailEvent(e.toString()));
          },
      );
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameSubject.close();
    _phoneSubject.close();
    _emailSubject.close();
    _passSubject.close();
    _btnSubject.close();
  }
}
