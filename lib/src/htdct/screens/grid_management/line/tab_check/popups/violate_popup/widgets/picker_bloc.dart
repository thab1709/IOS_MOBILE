// @dart=2.9
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../../../../models/location_model.dart';

class PickerBloc extends ChangeNotifier {
  PickerBloc(LatLng location) {
    currentLocation = location;
  }

  StreamController<Location> locationController =
      StreamController<Location>.broadcast();
  LatLng currentLocation;

  void locationSelected(Location location) {
    locationController.sink.add(location);
  }

  @override
  void dispose() {
    debugPrint('picker_bloc: dispose()');
    locationController.close();
    super.dispose();
  }
}

