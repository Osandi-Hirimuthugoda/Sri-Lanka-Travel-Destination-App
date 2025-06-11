import 'package:flutter/material.dart';

class UserManualScreen extends StatelessWidget {
  const UserManualScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Manual'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Manual',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            _buildSection(
              context,
              'Getting Started',
              'Welcome to Sri Lanka Travel Guide! To begin exploring, simply open the app and browse through the home screen. '
                  'You can view destinations categorized by season (Summer or Winter).',
            ),
            _buildSection(
              context,
              'Exploring Destinations',
              'Browse destinations by scrolling through the list. Tap on any destination to view detailed information including '
                  'description, best season to visit, and things to do. You can also search for specific destinations using the search bar.',
            ),
            _buildSection(
              context,
              'Using the Map',
              'The map view shows all destinations marked on a map of Sri Lanka. You can filter destinations by category and search '
                  'for specific locations. Tap on any marker to see the destination name and tap again to view details.',
            ),
            _buildSection(
              context,
              'Managing Favorites',
              'You can mark destinations as favorites by tapping the heart icon. View all your favorite destinations in the '
                  'Favorites tab for quick access to your preferred locations.',
            ),
            _buildSection(
              context,
              'Customizing Settings',
              'Personalize your app experience in the Settings screen. You can toggle between light and dark mode, and change '
                  'the app language between English, Sinhala, and Tamil.',
            ),
            _buildSection(
              context,
              'About the App',
              'Sri Lanka Travel Guide is developed to help tourists and locals discover the beautiful destinations in Sri Lanka. '
                  'The app provides comprehensive information about each location to help plan your perfect trip.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}