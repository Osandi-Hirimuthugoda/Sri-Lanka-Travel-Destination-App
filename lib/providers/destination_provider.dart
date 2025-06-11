import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:travel_destination_app/models/destination.dart';

class DestinationProvider with ChangeNotifier {
  List<Destination> _destinations = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Destination> get destinations => _destinations;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDestinations() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      print('Loading destinations from assets/data/destinations.json');
      final String response = await rootBundle.loadString('assets/data/destinations.json');
      final List<dynamic> data = jsonDecode(response);
      _destinations = data.map((json) {
        // Convert JSON to match Destination model
        final modifiedJson = Map<String, dynamic>.from(json);
        // Handle "Yes"/"No" string for isVacationSpot
        if (modifiedJson['isVacationSpot'] is String) {
          modifiedJson['isVacationSpot'] = modifiedJson['isVacationSpot'] == 'Yes';
        }
        // Ensure id is provided if missing
        modifiedJson['id'] ??= UniqueKey().toString();
        return Destination.fromJson(modifiedJson);
      }).toList();
      print('Successfully loaded ${_destinations.length} destinations');
    } catch (e) {
      print('Error loading destinations: $e');
      _errorMessage = 'Failed to load destinations: $e';
      // Fallback to mock data
      _destinations = [
        Destination(
          id: '1',
          city: 'Colombo',
          province: 'Western',
          description: 'The capital city of Sri Lanka',
          imageUrl: 'assets/images/colombo.jpg',
          category: 'City',
          season: 'Summer',
          activities: ['Visit Galle Face Green', 'Explore National Museum'],
          galleryImages: ['assets/images/colombo1.jpg', 'assets/images/colombo2.jpg'],
          rating: 4.5,
          latitude: 6.9271,
          longitude: 79.8612,
          address: 'Colombo, Western Province',
          bestTimeToVisit: 'May-Sep',
          contactNumber: '+94 11 123 4567',
          entranceFee: 'Free',
          openingHours: 'Open 24/7',
          isVacationSpot: true,
        ),
        Destination(
          id: '2',
          city: 'Kandy',
          province: 'Central',
          description: 'Cultural capital with Temple of the Tooth',
          imageUrl: 'assets/images/kandy.jpg',
          category: 'Cultural',
          season: 'Winter',
          activities: ['Visit Temple of the Tooth', 'Walk around Kandy Lake'],
          galleryImages: ['assets/images/kandy1.jpg'],
          rating: 4.7,
          latitude: 7.2906,
          longitude: 80.6337,
          address: 'Kandy, Central Province',
          bestTimeToVisit: 'Dec-Apr',
          contactNumber: '+94 81 123 4567',
          entranceFee: 'LKR 1500',
          openingHours: '8:00 AM - 5:00 PM',
          isVacationSpot: true,
        ),
      ];
      print('Using fallback data: ${_destinations.length} destinations');
    }
    _isLoading = false;
    notifyListeners();
  }
}