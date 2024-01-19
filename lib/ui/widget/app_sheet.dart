import 'package:flutter/material.dart';

class AppSheet {
  static show<T>(
      {required BuildContext context, required WidgetBuilder builder}) async {
    return await showModalBottomSheet<T>(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      isDismissible: true,
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: builder,
      useRootNavigator: false,
    );
  }
}
