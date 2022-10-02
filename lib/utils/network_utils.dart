import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtils {
  // checks for internet connection- wifi/mobile data.
  Future<int> isNetworkAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      return 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      return 1;
    } else if (connectivityResult == ConnectivityResult.none) {
      // No internet connection.
      return 0;
    }
    return 0;
  }
}
