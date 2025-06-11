import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomGoogleMapController with ChangeNotifier {
  GoogleMapController? _mapController;

  GoogleMapController? get mapController => _mapController;

  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  void centerMap(LatLng target, double zoom) {
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
    notifyListeners();
  }

  void disposeController() {
    _mapController?.dispose();
    _mapController = null;
    notifyListeners();
  }
}