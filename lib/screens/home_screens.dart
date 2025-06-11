import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_destination_app/providers/destination_provider.dart';
import 'package:travel_destination_app/screens/about_screen.dart';
import 'package:travel_destination_app/screens/detail_screen.dart';
import 'package:travel_destination_app/screens/favorites_screen.dart';
import 'package:travel_destination_app/screens/map_screen.dart';
import 'package:travel_destination_app/screens/settings_screen.dart';
import '../models/destination.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _selectedIndex = 0;

  static List<Widget Function(BuildContext, String)> _widgetBuilders = <Widget Function(BuildContext, String)>[
    _buildHomeContent,
        (context, _) => const FavoritesScreen(),
        (context, _) => const MapScreen(),
        (context, _) => const SettingsScreen(),
        (context, _) => const AboutScreen(),
  ];

  static Widget _buildHomeContent(BuildContext context, String searchQuery) {
    return _HomeContent(searchQuery: searchQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Selected bottom nav index: $index');
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building HomeScreen');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sri Lanka Travel Destinations'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                          print('Search query: $_searchQuery');
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search by city, province, category, or vacation spot...',
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
            child: Builder(
              builder: (context) => _widgetBuilders[_selectedIndex](context, _searchQuery),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final String searchQuery;

  const _HomeContent({required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    print('Building HomeContent with search: $searchQuery');
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Summer (May-Sep)'),
              Tab(text: 'Winter (Dec-Apr)'),
            ],
          ),
          Expanded(
            child: Consumer<DestinationProvider>(
              builder: (context, provider, child) {
                print('Destinations count: ${provider.destinations.length}, isLoading: ${provider.isLoading}');
                if (provider.isLoading) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Loading destinations...'),
                      ],
                    ),
                  );
                }
                if (provider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${provider.errorMessage}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.loadDestinations(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                if (provider.destinations.isEmpty) {
                  return const Center(child: Text('No destinations available'));
                }
                return TabBarView(
                  children: [
                    _buildSeasonView(
                      context,
                      provider.destinations
                          .where((d) => d.season.toLowerCase() == 'summer')
                          .where((d) =>
                      searchQuery.isEmpty ||
                          d.city.toLowerCase().contains(searchQuery) ||
                          d.province.toLowerCase().contains(searchQuery) ||
                          d.category.toLowerCase().contains(searchQuery) ||
                          (d.isVacationSpot ? 'yes' : 'no').contains(searchQuery))
                          .toList(),
                    ),
                    _buildSeasonView(
                      context,
                      provider.destinations
                          .where((d) => d.season.toLowerCase() == 'winter')
                          .where((d) =>
                      searchQuery.isEmpty ||
                          d.city.toLowerCase().contains(searchQuery) ||
                          d.province.toLowerCase().contains(searchQuery) ||
                          d.category.toLowerCase().contains(searchQuery) ||
                          (d.isVacationSpot ? 'yes' : 'no').contains(searchQuery))
                          .toList(),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeasonView(BuildContext context, List<Destination> destinations) {
    print('Building season view with ${destinations.length} destinations');
    final provinces = destinations.map((d) => d.province).toSet().toList();

    return ListView.builder(
      itemCount: provinces.length,
      itemBuilder: (context, index) {
        final province = provinces[index];
        final provinceDestinations = destinations.where((d) => d.province == province).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                province,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...provinceDestinations.map((destination) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: Image.asset(
                  destination.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
                title: Text(destination.city),
                subtitle: Text('${destination.category} - ${destination.isVacationSpot ? 'Vacation Spot' : 'Other'}'),
                trailing: IconButton(
                  icon: Icon(
                    destination.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: destination.isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    final provider = Provider.of<DestinationProvider>(context, listen: false);
                    destination.isFavorite = !destination.isFavorite;
                    provider.notifyListeners();
                    print('Toggled favorite for ${destination.city}: ${destination.isFavorite}');
                  },
                ),
                onTap: () {
                  print('Navigating to DetailScreen for ${destination.city}');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(destination: destination),
                    ),
                  );
                },
              ),
            )),
            if (index < provinces.length - 1) const Divider(thickness: 1, color: Colors.grey),
          ],
        );
      },
    );
  }
}