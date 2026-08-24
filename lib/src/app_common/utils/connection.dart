// @dart=2.9
import 'package:internet_connection_checker/internet_connection_checker.dart';

class Connection {
  static final shared = Connection();

  Future<bool> isHasConnection() async {
    final result = await InternetConnectionChecker().hasConnection;
    return result;
  }

}
