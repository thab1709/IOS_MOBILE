// @dart=2.9
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'picker_bloc.dart';

class
MapPicker extends StatefulWidget {
  final PickerBloc bloc;
  final LatLng position;
  const MapPicker(this.bloc, this.position);

  @override
  State<MapPicker> createState() => MapPickerState();
}

class MapPickerState extends State<MapPicker> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  void initState() {
    super.initState();

    widget.bloc.locationController.stream.listen(
          (location) async {
        final mapController = await _controller.future;
        await mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(
                location.lat,
                location.lng,
              ),
              zoom: 15,
            ),
          ),
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: widget.position,
            zoom: 15,
          ),
          onMapCreated: (controller) {
            _controller.complete(controller);
          },
          onCameraMove: (newPosition) async {
            widget.bloc.currentLocation = LatLng(
               newPosition.target.latitude, newPosition.target.longitude,
            );
          },
        ),
        const Center(
          child: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 36,
          ),
        ),
      ],
    );
  }
}
