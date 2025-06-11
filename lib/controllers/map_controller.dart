import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travel_destination_app/models/destination.dart';

class MapController with ChangeNotifier {
  final Set<Marker> _markers = {};
  String _selectedFilter = 'All';
  String _searchQuery = '';
  final List<String> _filters = ['All', 'Summer', 'Winter', 'Beach', 'Cultural', 'Urban', 'Nature'];

  Set<Marker> get markers => _markers;
  String get selectedFilter => _selectedFilter;
  List<String> get filters => _filters;

  void updateMarkers(List<Destination> destinations, BuildContext context) async {
    _markers.clear();
    for (var destination in destinations) {
      if (_selectedFilter != 'All' &&
          destination.season.toLowerCase() != _selectedFilter.toLowerCase() &&
          destination.category.toLowerCase() != _selectedFilter.toLowerCase()) {
        continue;
      }
      if (_searchQuery.isNotEmpty &&
          !destination.city.toLowerCase().contains(_searchQuery) &&
          !destination.province.toLowerCase().contains(_searchQuery) &&
          !destination.category.toLowerCase().contains(_searchQuery)) {
        continue;
      }

      final markerIcon = await _getMarkerIcon(destination.category);
      _markers.add(
        Marker(
          markerId: MarkerId(destination.city),
          position: LatLng(destination.latitude, destination.longitude),
          infoWindow: InfoWindow(
            title: destination.city,
            snippet: '${destination.category} - ${destination.season}',
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: destination);
            },
          ),
          icon: markerIcon,
        ),
      );
    }
    notifyListeners();
  }

  Future<BitmapDescriptor> _getMarkerIcon(String category) async {
    String iconPath;
    switch (category.toLowerCase()) {
      case 'beach':
        iconPath = 'assets/icons/beach.png';
        break;
      case 'cultural':
        iconPath = 'assets/icons/temple.png';
        break;
      case 'urban':
        iconPath = 'assets/icons/city.png';
        break;
      case 'nature':
        iconPath = 'assets/icons/nature.png';
        break;
      default:
        iconPath = 'assets/icons/default.png';
    }
    try {
      return await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        iconPath,
      );
    } catch (e) {
      debugPrint('Error loading marker icon: $e');
      return BitmapDescriptor.defaultMarker;
    }
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }
}