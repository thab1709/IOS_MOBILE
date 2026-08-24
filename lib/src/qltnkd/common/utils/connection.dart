// @dart=2.9
import 'package:evnmobile/app_env.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class RConnection {
  static final shared = RConnection();

  bool _cachedResult = true;
  DateTime _lastCheck;
  Future<bool> _pendingCheck;

  static const _cacheDuration = Duration(seconds: 4);

  Future<bool> checkConnection() async {
    if (AppEnv.getAppEnv() == ENV.local) {
      return true;
    }
    final now = DateTime.now();

    // Reuse in-flight check if one is already running
    if (_pendingCheck != null) {
      return _pendingCheck;
    }

    // Return cached result if still fresh
    if (_lastCheck != null && now.difference(_lastCheck) < _cacheDuration) {
      return _cachedResult;
    }

    // Do a fresh check
    _pendingCheck = InternetConnectionChecker().hasConnection.then((result) {
      _cachedResult = result;
      _lastCheck = DateTime.now();
      _pendingCheck = null;
      return result;
    });

    return _pendingCheck;
  }
}

