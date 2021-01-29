import 'package:fluttertoast/fluttertoast.dart';

DateTime currentBackPressTime;
Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    Fluttertoast.showToast(msg: 'Double Click to exit app');
    return Future.value(false);
  }
  return Future.value(true);
}
