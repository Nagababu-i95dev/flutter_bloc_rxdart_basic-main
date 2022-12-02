import 'package:flutter/material.dart';
import 'package:poc_bloc/global.dart';
import 'package:poc_bloc/src/utils/color.dart';

class SnackBarDisplay {
  static buildSnackBar(String message, bool colorStatus) {
    final SnackBar snackBar = SnackBar(
      content: Text(message, style: const TextStyle(fontSize: 20, color: Colors.black ), textAlign: TextAlign.center,),
      backgroundColor: colorStatus? ColorUtils.SUCCESS_COLOR : ColorUtils.ERROR_COLOR ,
      duration: const Duration(seconds: 2),
    );
    snackBarKey.currentState?.showSnackBar(snackBar).close;
  }
}
