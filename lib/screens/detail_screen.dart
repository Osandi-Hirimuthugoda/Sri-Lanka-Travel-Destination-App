import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:travel_destination_app/models/destination.dart';

class DetailScreen extends StatelessWidget {
  final Destination destination;

  const DetailScreen({super.key, required this.destination});

  Future<void> _launchMapsUrl(BuildContext context, double latitude, double longitude) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.city),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _shareDestination(destination);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'destination-image-${destination.id}',
              child: Image.asset(
                destination.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '⭐ ${destination.rating}',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Chip(
                    label: Text(destination.category),
                    backgroundColor: Colors.teal.withOpacity(0.2),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                destination.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 16),
            _buildSectionHeader('Location'),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text('${destination.city}, ${destination.province}'),
              subtitle: Text(destination.address),
              onTap: () => _launchMapsUrl(context, destination.latitude, destination.longitude),
            ),
            _buildSectionHeader('Best Time to Visit'),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Best Season: ${destination.season} (${destination.season == 'Summer' ? 'May-Sep' : 'Dec-Apr'})',
              ),
            ),
            _buildSectionHeader('Things to Do'),
            ...destination.activities.map((activity) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Text('• $activity'),
            )),
            _buildSectionHeader('Photo Gallery'),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: destination.galleryImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        destination.galleryImages[index],
                        width: 150,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      ),
                    ),
                  );
                },
              ),
            ),
            _buildSectionHeader('Additional Information'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact: ${destination.contactNumber}'),
                  Text('Entrance Fee: ${destination.entranceFee}'),
                  Text('Opening Hours: ${destination.openingHours}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text('Get Directions'),
                  onPressed: () => _launchMapsUrl(context, destination.latitude, destination.longitude),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _shareDestination(Destination destination) {
    // Placeholder for share functionality
    // Share.share('Check out ${destination.city} in Sri Lanka! ${destination.description}');
  }
}