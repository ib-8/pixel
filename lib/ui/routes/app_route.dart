import 'package:flutter/material.dart';

class AppRoute {
  static Future<T> push<T extends Object?>(
      BuildContext context, Widget child) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => child,
      ),
    );
  }

  static void pop<T extends Object?>(BuildContext context) {
    Navigator.pop(context);
  }
}
