// toast_service.dart
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:san_sprito/common_widgets/color_constant.dart';

class ToastService {
  static void showSuccess(String message) {
    _showToast(message, CommonColor.logoBGColor);
  }

  static void showError(String message) {
    _showToast(message, Colors.red);
  }

  static void showInfo(String message) {
    _showToast(message, Colors.blue);
  }

  static void _showToast(String message, Color bgColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: bgColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
