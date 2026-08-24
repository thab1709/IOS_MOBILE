// @dart=2.9
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:evnmobile/src/htld/common/base/base_delegate.dart';
import 'package:evnmobile/src/htld/common/constance/image_path.dart';
import 'package:evnmobile/src/htld/common/constance/strings.dart';
import 'package:evnmobile/src/htld/common/extension/extension.dart';
import 'package:evnmobile/src/htld/screens/worker_location/map_page_controller.dart';
import 'package:evnmobile/src/htld/screens/worker_location/models/subtation_address.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'components/map_pin_pill.dart';
import 'models/pin_pill_info.dart';

const double CAMERA_ZOOM = 17;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 0;

class MapPage extends StatefulWidget {
  final SubstationAddress address;
  final int type;

  const MapPage({this.address, this.type});

  @override
  State<StatefulWidget> createState() => MapPageState();
}

class MapPageState extends State<MapPage> implements BaseDelegate {
  GoogleMapController mapController;
  final controlller = MapPageController();

  final Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  double pinPillPosition = -100;
  PinInformation currentlySelectedPin = PinInformation(
      pinPath: '',
      avatarPath: '',
      location: const LatLng(0, 0),
      title: '',
      labelColor: Colors.grey);
  PinInformation sourcePinInfo;

  @override
  void initState() {
    controlller.delegate = this;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future createMarkerLine() async {
    final lineMarkerIcon = await getBytesFromAsset('assets/images/transmission-white-circle.png', 50);
    final lineMarkers = controlller.lineKinks.map((e) {
      final position = LatLng(e.latitude, e.longitude);
      final info = PinInformation(
          title: e.name,
          subtitle2: e.code,
          subtitle: '${e.latitude}, ${e.longitude}',
          avatarPath: 'assets/images/transmission-white-circle.png',
          pinPath: 'assets/images/user_location.svg');
      return Marker(markerId: MarkerId(e.code), position: position, icon: BitmapDescriptor.fromBytes(lineMarkerIcon), onTap: () {
        setState(() {
          currentlySelectedPin = info;
          pinPillPosition = 0;
        });
      });
    })?.toList();
    _markers.addAll(lineMarkers);

    // User Marker
    final userMarkers = <Marker>[];
    final markerUserIcon =
    await getBytesFromAsset('assets/images/Road-Worker-1-icon.png', 80);
    if (controlller.userLocation != null) {
      controlller.userLocation.forEach((user) {
        if (user?.locations?.isNotEmpty ?? false) {
          final e = user.locations.last;
          final locationC = LatLng(e.latitude, e.longitude);
          // Convert time log for user location
          final updatedDt = user.timeLog.fromFormatUtcToFormatLocal('yy-MM-dd hh:mm');

          final info = PinInformation(
              title: user.name,
              subtitle2: user.code,
              subtitle: user.userGroup,
              avatarPath: 'assets/images/Road-Worker-1-icon.png',
              timeLog: updatedDt,
              pinPath: 'assets/images/user_location.svg');
          final markers = Marker(
            // This marker id can be anything that uniquely identifies each marker.
              markerId: MarkerId(user.userId),
              position: locationC,
              onTap: () {
                setState(() {
                  currentlySelectedPin = info;
                  pinPillPosition = 0;
                });
              },
              icon: BitmapDescriptor.fromBytes(markerUserIcon));
          userMarkers.add(markers);
        }
      });
    }
    _markers.addAll(userMarkers);
    setState(() {});

    final centerKink = controlller.lineKinks.first;
    final locationTarget = LatLng(centerKink.latitude, centerKink.longitude);
    await mapController.animateCamera(CameraUpdate.newLatLng(locationTarget));
  }

  Future createMarkerSubstation() async {

    // User Marker
    final userMarkers = <Marker>[];
    final markerUserIcon =
        await getBytesFromAsset('assets/images/Road-Worker-1-icon.png', 80);
    if (controlller.substationDetailLocation.userLocations != null) {
      controlller.substationDetailLocation.userLocations.forEach((user) {
        if (user?.locations?.isNotEmpty ?? false) {
          final e = user.locations.last;
          final locationC = LatLng(e.latitude, e.longitude);

          // Convert time log for user location
          final updatedDt = user.timeLog.fromFormatUtcToFormatLocal(AppStrings.ddmmyyyyHHmm);

          final info = PinInformation(
              title: user.name,
              subtitle2: user.code,
              subtitle: user.userGroup,
              avatarPath: 'assets/images/Road-Worker-1-icon.png',
              timeLog: updatedDt,
              pinPath: 'assets/images/user_location.svg');
          final markers = Marker(
            // This marker id can be anything that uniquely identifies each marker.
              markerId: MarkerId(user.userId),
              position: locationC,
              onTap: () {
                setState(() {
                  currentlySelectedPin = info;
                  pinPillPosition = 0;
                });
              },
              icon: BitmapDescriptor.fromBytes(markerUserIcon));
          userMarkers.add(markers);
        }
      });
    }

    //Substation Marker
    final locationSubstation = LatLng(
        controlller.substationDetailLocation.substationLatitude,
        controlller.substationDetailLocation.substationLongitude);
    final markerSubstationIcon =
        await getBytesFromAsset('assets/images/7531192.png', 100);
    final substationMarker = Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: const MarkerId('sourcePin'),
        position: locationSubstation,
        infoWindow: InfoWindow(
          title: widget.address.name
        ),
        onTap: () {
          setState(() {
            currentlySelectedPin = sourcePinInfo;
            pinPillPosition = 0;
          });
        },
        icon: BitmapDescriptor.fromBytes(markerSubstationIcon));
    sourcePinInfo = PinInformation(
        title: widget.address.name,
        subtitle: widget.address.lineName,
        subtitle2: widget.address.userGroups.join(', '),
        pinPath: ImagePath.substationLocation,
        avatarPath: 'assets/images/7531192.png',
        timeLog: widget.address.timeLog,
        labelColor: Colors.blueAccent);
    userMarkers.add(substationMarker);

    _markers.addAll(userMarkers);
    setState(() {});

    await mapController.animateCamera(CameraUpdate.newLatLng(locationSubstation));
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    Future.delayed(const Duration(milliseconds: 100), () {
      //Tram bien ap
      if (widget.type == 0) {
        controlller.getLocationDetail(widget.address.id ?? '');
      } else { // Duong day
        controlller.getLocationLineDetail(widget.address.id ?? '');
      }
    });
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    final data = await rootBundle.load(path);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    final fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
        .buffer
        .asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: true,
          title: Text(
            widget.address.name ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: Stack(children: <Widget>[
          buildGoogleMap(),
          MapPinPillComponent(
              pinPillPosition: pinPillPosition,
              currentlySelectedPin: currentlySelectedPin)
        ]));
  }

  Widget buildGoogleMap() {
    if (widget.type == 0) {
      final locationTarget = LatLng(widget.address.latitude, widget.address.longitude);

      final initialLocation = CameraPosition(
          zoom: CAMERA_ZOOM,
          bearing: CAMERA_BEARING,
          tilt: CAMERA_TILT,
          target: locationTarget);
      return GoogleMap(
        myLocationEnabled: false,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: onMapCreated,
        onTap: (location) {
          setState(() {
            pinPillPosition = -100;
          });
        },
      );
    } else {
      LatLng locationTarget;
      if (controlller.lineKinks.isEmpty ?? true) {
        locationTarget = const LatLng(0, 0);
      } else {
        final index = controlller.lineKinks.length/2;
        final centerKink = controlller.lineKinks[index.toInt()];
        locationTarget = LatLng(centerKink.latitude, centerKink.longitude);
      }

      final initialLocation = CameraPosition(
          zoom: CAMERA_ZOOM,
          bearing: CAMERA_BEARING,
          tilt: CAMERA_TILT,
          target: locationTarget);
      return GoogleMap(
        myLocationEnabled: false,
        compassEnabled: true,
        tiltGesturesEnabled: false,
        markers: _markers,
        polylines: _polyline,
        mapType: MapType.normal,
        initialCameraPosition: initialLocation,
        onMapCreated: onMapCreated,
        onTap: (location) {
          setState(() {
            pinPillPosition = -100;
          });
        },
      );
    }

  }

  @override
  void loadFailed(String message) {}

  @override
  void loadSuccess() {

    widget.type == 0 ? createMarkerSubstation() : createMarkerLine();
  }

  @override
  void onLoading() {}
}

