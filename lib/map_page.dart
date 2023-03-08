import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // int selectedIndex = 0;
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
    } catch (e) {
      _currentLocation = null;
    }
    if (_currentLocation != null) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(_currentLocation?.latitude ?? 0,
                _currentLocation?.longitude ?? 0),
            zoom: 15,
          ),
        ),
      );
    }
  }

  late GoogleMapController _mapController;
  final Location _location = Location();
  LocationData? _currentLocation;
  LatLng? latLng;
  Marker? marker;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          myLocationButtonEnabled: true,
          initialCameraPosition: const CameraPosition(
            target: LatLng(41.305986, 69.250475),
            zoom: 11,
          ),
          onMapCreated: (GoogleMapController controller) {
            _mapController = controller;
            _getCurrentLocation();
          },
          onTap: (argument) {
            latLng = argument;
            setState(() {});
          },
          markers: latLng != null
              ? {
                  Marker(
                    markerId: const MarkerId('current_location'),
                    position:
                        LatLng(latLng?.latitude ?? 0, latLng?.longitude ?? 0),
                    icon: BitmapDescriptor.defaultMarker,
                  ),
                }
              : <Marker>{},
        ),
      ]),
    );
  }
}