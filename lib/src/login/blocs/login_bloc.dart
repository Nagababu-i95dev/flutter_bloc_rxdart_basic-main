import 'dart:async';

import 'package:rxdart/rxdart.dart';

class LoginBloc
{
  final _loginIDController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  Stream<String> get loginId => _loginIDController.stream.transform(validateLoginID);
  Stream<String> get password => _passwordController.stream.transform(validatePassword);

  Sink<String> get sinkLoginId => _loginIDController.sink;
  Sink<String> get sinkPassword => _passwordController.sink;

  //considering loginId will be email id
  final validateLoginID = StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.length != 1) {
      isEmail(value) ? sink.add(value) : sink.addError('Enter Valid Email-ID');
    }
  });

  static bool isEmail(String email) {
    String regExp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    return (RegExp(regExp).hasMatch(email));
  }

  final validatePassword =
  StreamTransformer<String, String>.fromHandlers(handleData: (value, sink) {
    if (value.isNotEmpty) {
      (value.length >= 6 && value.length <= 15) ? sink.add(value) : sink.addError('Password should be between 6 to 15 characters long');
    }
  });

  Stream<bool> get submitValid =>
      Rx.combineLatest2(loginId, password , (l, p) => true);


  dispose() {
    _loginIDController.close();
    _passwordController.close();
  }
}

final login_bloc = LoginBloc();
