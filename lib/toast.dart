import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static show(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  static showAtTop(String msg) {
    Fluttertoast.showToast(msg: msg, gravity: ToastGravity.TOP);
  }
}
