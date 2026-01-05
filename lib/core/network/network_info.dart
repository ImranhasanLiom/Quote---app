
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo{
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);


  @override
  // TODO: implement isConnected
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult !=connectivityResult.nonNulls;


  }
}