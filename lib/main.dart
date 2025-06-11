import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_destination_app/controllers/custom_google_map_controller.dart';
import 'package:travel_destination_app/controllers/map_controller.dart';
import 'package:travel_destination_app/providers/destination_provider.dart';
import 'package:travel_destination_app/screens/detail_screen.dart';
import 'package:travel_destination_app/screens/settings_screen.dart';
import 'package:travel_destination_app/screens/splash_screen.dart';

import 'models/destination.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => DestinationProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => MapController()),
        ChangeNotifierProvider(create: (context) => CustomGoogleMapController()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sri Lanka Travel Destinations',
            theme: ThemeData(
              primarySwatch: Colors.teal,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.teal,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: themeProvider.themeMode,
            home: const SplashScreen(),
            routes: {
              '/detail': (context) => DetailScreen(
                destination: ModalRoute.of(context)!.settings.arguments as Destination,
              ),
            },
          );
        },
      ),
    );
  }
}