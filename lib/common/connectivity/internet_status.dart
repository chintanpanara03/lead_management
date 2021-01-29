import 'package:connectivity/connectivity.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> internetStatus() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    errorMessage();
    return false;
  }
}

errorMessage() {
  Fluttertoast.showToast(msg: 'Please Check Your \n Internet Connection');
}
