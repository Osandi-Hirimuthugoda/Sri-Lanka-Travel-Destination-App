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
    });
  }

  @override
  Widget build(BuildContext context) {
    final destinationProvider = Provider.of<DestinationProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      destinationProvider.loadDestinations();
    });

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
                if (provider.destinations.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                return TabBarView(
                  children: [
                    _buildSeasonView(context, provider.destinations
                        .where((d) => d.season?.toLowerCase() == 'summer')
                        .where((d) =>
                    searchQuery.isEmpty ||
                        (d.city?.toLowerCase() ?? '').contains(searchQuery) ||
                        (d.province?.toLowerCase() ?? '').contains(searchQuery) ||
                        (d.category?.toLowerCase() ?? '').contains(searchQuery) ||
                        (d.isVacationSpot?.toLowerCase() ?? '').contains(searchQuery))
                        .toList()),
                    _buildSeasonView(context, provider.destinations
                        .where((d) => d.season?.toLowerCase() == 'winter')
                        .where((d) =>
                    searchQuery.isEmpty ||
                        (d.city?.toLowerCase() ?? '').contains(searchQuery) ||
                        (d.province?.toLowerCase() ?? '').contains(searchQuery) ||
                        (d.category?.toLowerCase() ?? '').contains(searchQuery) ||
                        (d.isVacationSpot?.toLowerCase() ?? '').contains(searchQuery))
                        .toList()),
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
                province ?? 'Unknown Province',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...provinceDestinations.map((destination) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: Image.asset(
                  destination.imageUrl ?? '',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
                title: Text(destination.city ?? 'Unknown City'),
                subtitle: Text('${destination.category ?? 'Unknown'} - ${destination.isVacationSpot ?? 'No'}'),
                trailing: IconButton(
                  icon: Icon(
                    destination.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: destination.isFavorite ? Colors.red : null,
                  ),
                  onPressed: () {
                    final provider = Provider.of<DestinationProvider>(context, listen: false);
                    destination.isFavorite = !destination.isFavorite;
                    provider.notifyListeners(); // Update UI
                  },
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailScreen(destination: destination),
                    ),
                  );
                },
              ),
            )),
            if (index < provinces.length - 1) const Divider(thickness: 1, color: Colors.grey), // Add divider between provinces
          ],
        );
      },
    );
  }
}