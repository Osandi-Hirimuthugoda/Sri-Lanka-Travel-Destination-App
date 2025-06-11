import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_destination_app/providers/destination_provider.dart';
import 'package:travel_destination_app/screens/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      print('Preloading destinations in SplashScreen');
      final destinationProvider = Provider.of<DestinationProvider>(context, listen: false);
      await destinationProvider.loadDestinations();
      print('Destinations loaded: ${destinationProvider.destinations.length}');
      await Future.delayed(const Duration(seconds: 3));
      if (mounted) {
        print('Navigating to MainScreen');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/travel_icon.jpg', width: 100),
            const SizedBox(height: 20),
            const Text(
              'Sri Lanka Travel',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}