import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:travel_destination_app/models/destination.dart';

class DestinationProvider with ChangeNotifier {
  List<Destination> _destinations = [];

  List<Destination> get destinations => _destinations;

  Future<void> loadDestinations() async {
    try {
      final String response = await rootBundle.loadString('assets/data/destinations.json');
      final List<dynamic> data = jsonDecode(response);
      _destinations = data.map((json) => Destination.fromJson(json)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading destinations: $e');
    }
  }
}