import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_destination_app/providers/destination_provider.dart';
import 'package:travel_destination_app/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DestinationProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Travel Destinations',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}git remote add origin https://github.com/USERNAME/REPO_NAME.git