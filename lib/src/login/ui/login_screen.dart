import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:poc_bloc/src/login/blocs/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';

  final _passwordFocusNode = FocusNode();
  final _forgotPasswordFocusNode = FocusNode();
  final _loginFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  Widget renderAlertDialog(String message) {
    return AlertDialog(
      title: const Text('Status'),
      content: Text(message),
      actions: [
        ElevatedButton(
          child: const Text("OK"),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _form,
          child: ListView(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: const Text(
                    'COMPANY NAME',
                    style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  )),
              const SizedBox(
                height: 40,
              ),
              StreamBuilder<String>(
                  stream: login_bloc.loginId,
                  builder: (context, snapshot) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        onChanged: (val) => login_bloc.sinkLoginId.add(val),
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'User Name',
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },

                      ),
                    );
                  }),
              StreamBuilder<String>(
                  stream: login_bloc.password,
                  builder: (context, snapshot) {
                    return Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextFormField(
                        onChanged: (val) => login_bloc.sinkPassword.add(val),
                        obscureText: true, // to hide the text entered
                        decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: 'Password',
                            errorText: snapshot.hasError
                                ? snapshot.error.toString()
                                : null),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+')),
                        ],
                        focusNode: _passwordFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_forgotPasswordFocusNode);
                        },
                      ),
                    );
                  }),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {},
                  focusNode: _forgotPasswordFocusNode,
                  onFocusChange: (_) {
                    FocusScope.of(context).requestFocus(_loginFocusNode);
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  )),
              StreamBuilder<bool>(
                  stream: login_bloc.submitValid,
                  builder: (context, validData) {
                    return Container(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(context: context, builder: (BuildContext context) {
                            if (validData.data == true) {
                              return renderAlertDialog('Login Successful');
                            } else {
                              return renderAlertDialog('Login Not Successful');
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: validData.data != true
                                ? Colors.grey[200]
                                : Colors.blue),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                    child: Text('Does not have account?'),
                  ),
                  TextButton(
                    onPressed: () {
                      //signup screen
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
