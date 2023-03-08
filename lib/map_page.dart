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

  Future<void> _getCurrentLocation() async {
    try {
      _currentLocation = await _location.getLocation();
    } catch (e) {
      _currentLocation = null;
    }
    if (_currentLocation != null) {
      latLng = LatLng(
          _currentLocation?.latitude ?? 0, _currentLocation?.longitude ?? 0);
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
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Stack(children: [
          GoogleMap(
            myLocationEnabled: true,
            zoomControlsEnabled: false,
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
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: InkWell(
              onTap: () {
                Navigator.pop(context, [latLng]);
              },
              child: Container(
                height: 44,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8), color: Colors.blue),
                child: const Center(
                    child: Text(
                  'Ortga qaytish',
                  style: TextStyle(color: Colors.white),
                )),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
