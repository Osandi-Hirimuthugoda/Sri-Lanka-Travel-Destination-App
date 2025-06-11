import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:travel_destination_app/controllers/custom_google_map_controller.dart';
import 'package:travel_destination_app/controllers/map_controller.dart';
import 'package:travel_destination_app/providers/destination_provider.dart';

class MapScreen extends StatefulWidget {
const MapScreen({super.key});

@override
State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
final TextEditingController _searchController = TextEditingController();

@override
void initState() {
super.initState();
_searchController.addListener(() {
Provider.of<MapController>(context, listen: false)
    .setSearchQuery(_searchController.text);
Provider.of<MapController>(context, listen: false)
    .updateMarkers(Provider.of<DestinationProvider>(context, listen: false).destinations, context);
});
}

@override
void dispose() {
_searchController.dispose();
Provider.of<CustomGoogleMapController>(context, listen: false).disposeController();
super.dispose();
}

@override
Widget build(BuildContext context) {
final destinationProvider = Provider.of<DestinationProvider>(context);
final mapController = Provider.of<MapController>(context);
final googleMapController = Provider.of<CustomGoogleMapController>(context);

return Scaffold(
appBar: AppBar(
title: const Text('Map View'),
actions: [
DropdownButton<String>(
value: mapController.selectedFilter,
items: mapController.filters.map((filter) {
return DropdownMenuItem(value: filter, child: Text(filter));
}).toList(),
onChanged: (filter) {
if (filter != null) {
mapController.setFilter(filter);
mapController.updateMarkers(destinationProvider.destinations, context);
}
},
),
],
),
body: Column(
children: [
Padding(
padding: const EdgeInsets.all(8.0),
child: Container(
decoration: BoxDecoration(
color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
borderRadius: BorderRadius.circular(8.0),
border: Border.all(color: Colors.grey),
),
child: Row(
children: [
const Icon(Icons.search),
Expanded(
child: TextField(
controller: _searchController,
decoration: const InputDecoration(
hintText: 'Search destinations...',
border: InputBorder.none,
contentPadding: EdgeInsets.all(8.0),
),
),
),
],
),
),
),
Expanded(
child: destinationProvider.destinations.isEmpty
? const Center(child: CircularProgressIndicator())
    : GoogleMap(
initialCameraPosition: const CameraPosition(
target: LatLng(7.8731, 80.7718), // Sri Lanka center
zoom: 7.5,
),
markers: mapController.markers,
onMapCreated: (GoogleMapController controller) {
googleMapController.onMapCreated(controller);
mapController.updateMarkers(destinationProvider.destinations, context);
},
),
),
],
),
floatingActionButton: FloatingActionButton(
onPressed: () {
googleMapController.centerMap(const LatLng(7.8731, 80.7718), 7.5);
},
child: const Icon(Icons.my_location),
),
);
}
}
