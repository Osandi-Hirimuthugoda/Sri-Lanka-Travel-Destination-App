import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travel_destination_app/providers/theme_provider.dart';
import 'package:travel_destination_app/screens/user_manual_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> showLanguageSelectionDialog(BuildContext context) async {
    final String? selectedLanguage = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Sinhala', 'Tamil'].map((lang) {
            return ListTile(
              title: Text(lang),
              onTap: () {
                Navigator.pop(context, lang);
              },
            );
          }).toList(),
        ),
      ),
    );

    if (selectedLanguage != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language', selectedLanguage);
      final locale = switch (selectedLanguage) {
        'Sinhala' => const Locale('si'),
        'Tamil' => const Locale('ta'),
        _ => const Locale('en'),
      };
      Provider.of<ThemeProvider>(context, listen: false).setLocale(locale);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About App'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.asset(
                  'assets/images/travel_icon.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Sri Lanka Travel Guide',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Discover the best travel destinations in Sri Lanka with our comprehensive guide. '
                  'Explore beautiful locations, plan your trips, and save your favorite spots.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Developed by:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Osandi Hirimuthugodage\nColombo, Sri Lanka',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Contact Us:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Email: support@travelapp.lk\nWebsite: www.travelapp.lk',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                showLanguageSelectionDialog(context);
              },
              icon: const Icon(Icons.language),
              label: const Text('Change Language'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const UserManualScreen()),
                );
              },
              icon: const Icon(Icons.book),
              label: const Text('User Manual'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}