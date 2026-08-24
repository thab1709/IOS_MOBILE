// @dart=2.9
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'map_picker.dart';
import 'picker_bloc.dart';

class MapPickerPage extends StatelessWidget {
  final LatLng currentLocation;

  const MapPickerPage({Key key, this.currentLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vị trí'),
      ),
      body: ChangeNotifierProvider<PickerBloc>(
        // builder: (context) => (PickerBloc.getInstance(),Container()),
        create: (_) => PickerBloc(currentLocation),
        child: MapPickerBody(currentLocation: currentLocation),
      ),
      // body: MapPickerBody(),
    );
  }
}

class MapPickerBody extends StatelessWidget {
  final LatLng currentLocation;

  const MapPickerBody({Key key, this.currentLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PickerBloc>(
      builder: (context, bloc, child) => Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                MapPicker(bloc, currentLocation),
                // SearchBox(bloc),
              ],
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final pickerBloc = Provider.of<PickerBloc>(context);
    return Container(
      height: 90,
      width: double.infinity,
      color: Colors.blue[50],
      child: FractionallySizedBox(
        widthFactor: 0.7,
        heightFactor: 0.5,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          onPressed: () {
            Get.back(result: pickerBloc.currentLocation);
          },
          child: const Text(
            'Chọn',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }
}

