import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:sql_db/http_helper/get_dart.dart';

Future getWebDataIfInternetAvailable() async {
  // var _connectionStatus = 'Unknown';

  // Read Internet Connectivity
  var connectivityResult = await (Connectivity().checkConnectivity());

// Check Internet Connection is Enable
  if ((connectivityResult == ConnectivityResult.mobile) ||
      (connectivityResult == ConnectivityResult.wifi)) {
    print('Internet is Connected!');
    await getDataFromWeb();
  } else {
    print('Please Connect to the Internet');
    // return 'Please Connect to the Internet';
  }
}
