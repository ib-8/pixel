import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

typedef StateWidgetBuilder<T> = Widget Function(BuildContext context, T value);

class StateBuilder<T> extends StatelessWidget {
  const StateBuilder({
    required this.controller,
    required this.builder,
    super.key,
  });

  final ValueListenable<T> controller;
  final StateWidgetBuilder<T> builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T>(
      valueListenable: controller,
      builder: (context, value, child) {
        return builder(context, value);
      },
    );
  }
}
