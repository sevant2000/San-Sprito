import 'package:flutter/material.dart';

class NavigationHelper {
  static void back(BuildContext context, [result]) {
    return Navigator.pop(context, result);
  }

  static Future<T?> navigate<T extends Object>(
      BuildContext context,
      Widget widget, {
        bool rootNavigator = false,
        bool popSelf = false,
      }) {
    if (popSelf) {
      return Navigator.of(context, rootNavigator: rootNavigator)
          .pushReplacement(
        MaterialPageRoute(builder: (_) => widget),
      );
    }
    return Navigator.of(context, rootNavigator: rootNavigator).push(
      MaterialPageRoute(builder: (_) => widget),
    );
  }

  static Future<T?> pushAndRemoveUntil<T extends Object>(
      BuildContext context, Widget widget) {
    return Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => widget),
            (Route<dynamic> route) => false);
  }

  static Route createRoute(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
