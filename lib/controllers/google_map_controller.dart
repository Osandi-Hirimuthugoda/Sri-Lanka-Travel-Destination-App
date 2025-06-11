// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class GoogleMapController extends ChangeNotifier {
//   GoogleMapController? _mapController;
//
//   // Initialize map controller
//   void onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//     notifyListeners();
//   }
//
//   // Center map on a specific location
//   void centerMap(LatLng target, double zoom) {
//     _mapController?.animateCamera(
//       CameraUpdate.newCameraPosition(
//         CameraPosition(target: target, zoom: zoom),
//       ),
//     );
//   }
//
//   // Dispose controller
//   void disposeController() {
//     _mapController?.dispose();
//     _mapController = null;
//     notifyListeners();
//   }
// }