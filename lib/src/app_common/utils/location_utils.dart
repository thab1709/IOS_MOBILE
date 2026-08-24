// @dart=2.9
import 'package:geolocator/geolocator.dart';

class LocationUtils {
  /// Kiểm tra & yêu cầu quyền truy cập vị trí
  static Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Kiểm tra GPS đã bật chưa
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false; // GPS chưa bật
    }

    // Kiểm tra quyền
    permission = await Geolocator.checkPermission();

    // Chưa cấp quyền
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    // Bị từ chối vĩnh viễn
    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Lấy vị trí hiện tại (Latitude, Longitude)
  static Future<Position> getCurrentLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print("❌ Lỗi lấy vị trí: $e");
      return null;
    }
  }

  /// Trả về lat, lng dạng Map<String, double>
  static Future<Map<String, double>> getLatLng() async {
    final position = await getCurrentLocation();
    if (position == null) return null;

    return {
      'lat': position.latitude,
      'lng': position.longitude,
    };
  }
}

