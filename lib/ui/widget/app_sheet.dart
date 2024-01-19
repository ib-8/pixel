import 'package:flutter/material.dart';

class AppSheet {
  static show(
      {required BuildContext context, required WidgetBuilder builder}) async {
    await showModalBottomSheet(
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
