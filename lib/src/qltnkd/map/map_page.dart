// @dart=2.9
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:evnmobile/src/htld/common/constance/image_path.dart';
import 'package:evnmobile/src/qltnkd/common/constance/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:evnmobile/src/qltnkd/common/extension/extension.dart';

import 'components/map_pin_pill.dart';
import 'map_page_controller.dart';
import 'model/pin_pill_info.dart';

const double CAMERA_ZOOM = 17;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 0;

class RMapPage extends StatefulWidget {
  final String location;
  final String scheduledId;
  final String equipmentDetail;
  final String workType;
  final String createDate;

  const RMapPage({
    @required this.location,
    @required this.scheduledId,
    @required this.equipmentDetail,
    @required this.workType,
    @required this.createDate,
  });

  @override
  State<StatefulWidget> createState() => RMapPageState();
}

class RMapPageState extends State<RMapPage> {
  GoogleMapController mapController;
  final controller = ReportMapPageController();

  final Set<Marker> _markers = {};

  double pinPillPosition = -100;
  RPinInformation currentlySelectedPin = RPinInformation(
      pinPath: 'assets/images/user_location.svg',
      avatarPath: 'assets/images/Road-Worker-1-icon.png',
      location: const LatLng(0, 0),
      title: '',
      labelColor: Colors.grey);
  RPinInformation sourcePinInfo;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      controller.getReportLocation(widget.scheduledId);
    });
  }

  Future createMarkerSubstation() async {
    // User Marker
    final userMarkers = <Marker>[];
    final markerUserIcon =
        await getBytesFromAsset('assets/images/Road-Worker-1-icon.png', 80);
    controller?.userLocations?.forEach((user) {
      if (user.latitude != null) {
        final locationC = LatLng(user.getLatitude(), user.getLongitude());

        // Convert time log for user location
        final updatedDt = user?.createdDate?.fromFormatUtcToFormatLocal(RAppStrings.ddmmyyyyHHmm) ?? '';

        final info = RPinInformation(
            title: user?.name ?? '',
            subtitle2: user?.code ?? '',
            subtitle: user?.departmentName ?? '',
            avatarPath: 'assets/images/Road-Worker-1-icon.png',
            timeLog: updatedDt,
            pinPath: 'assets/images/user_location.svg');
        final markers = Marker(
          // This marker id can be anything that uniquely identifies each marker.
            markerId: MarkerId(user?.id ?? ''),
            position: locationC,
            onTap: () {
              setState(() {
                currentlySelectedPin = info;
                pinPillPosition = 0;
              });
            },
            icon: BitmapDescriptor.fromBytes(markerUserIcon));
        userMarkers.add(markers);
        setState(() {

        });
      }
    });


    //Substation Marker
    LatLng focusLocation;
    if (controller.substationLocation.latitude != null) {
      focusLocation = LatLng(controller.substationLocation.getLatitude(),
          controller.substationLocation.getLongitude());

      final markerSubstationIcon = await getBytesFromAsset('assets/images/7531192.png', 100);
      final substationMarker = Marker(
          // This marker id can be anything that uniquely identifies each marker.
          markerId: const MarkerId('sourcePin'),
          position: focusLocation,
          infoWindow: InfoWindow(title: widget.location),
          onTap: () {
            setState(() {
              currentlySelectedPin = sourcePinInfo;
              pinPillPosition = 0;
            });
          },
          icon: BitmapDescriptor.fromBytes(markerSubstationIcon));
      userMarkers.add(substationMarker);
    } else {
      focusLocation = LatLng(controller.userLocations.firstOrNull.getLatitude(),
          controller.userLocations.firstOrNull.getLongitude());
    }

    sourcePinInfo = RPinInformation(
        title: widget.location,
        subtitle: widget.equipmentDetail,
        subtitle2: widget.workType,
        pinPath: ImagePath.substationLocation,
        avatarPath: 'assets/images/7531192.png',
        timeLog: widget.createDate,
        labelColor: Colors.blueAccent);

    _markers.addAll(userMarkers);

    await mapController.animateCamera(CameraUpdate.newLatLng(focusLocation));
  }

  void onMapCreated(GoogleMapController mapController) {
    this.mapController = mapController;
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
            widget.location ?? '',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        body: Obx(() {
          if(controller?.userLocations?.isNotEmpty == true){
            createMarkerSubstation();
            return Stack(children: <Widget>[
              buildGoogleMap(),
              RMapPinPillComponent(
                  pinPillPosition: pinPillPosition,
                  currentlySelectedPin: currentlySelectedPin)
            ]);
          } else {
            return Container();
          }

        }));
  }

  Widget buildGoogleMap() {
    LatLng locationTarget;

    if (controller.substationLocation.latitude != null) {
      locationTarget = LatLng(controller.substationLocation.getLatitude(),
          controller.substationLocation.getLongitude());
    } else {
      locationTarget = LatLng(controller.userLocations.firstOrNull.getLatitude(),
          controller.userLocations.firstOrNull.getLongitude());
    }

    _markers.removeWhere((element) => element == null);

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
  }
}

