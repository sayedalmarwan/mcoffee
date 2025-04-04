import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mcoffee/menu.dart';
import 'package:mcoffee/profile.dart';
import 'package:mcoffee/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CafePage extends StatefulWidget {
  const CafePage({super.key});

  @override
  State<CafePage> createState() => _CafePageState();
}

class _CafePageState extends State<CafePage> {
  late final MapController mapController;
  int selectedStoreIndex = -1;

  static const stores = [
    Store(
      name: 'Calicut',
      location: 'Magic Coffee, Downtown, Calicut',
      coordinates: LatLng(11.2588, 75.7804),
      rating: 4.5,
    ),
    Store(
      name: 'Thrissur',
      location: 'Magic Coffee, City Center, Thrissur',
      coordinates: LatLng(10.5276, 76.2144),
      rating: 4.8,
    ),
    Store(
      name: 'Kochi',
      location: 'Magic Coffee, Marine Drive, Kochi',
      coordinates: LatLng(9.9312, 76.2673),
      rating: 4.7,
    ),
  ];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  void _onStoreSelected(Store store) async {
    final index = stores.indexOf(store);
    setState(() => selectedStoreIndex = index);
    mapController.move(store.coordinates, 15);

    // Save selected store to Firebase
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final databaseRef = FirebaseDatabase.instance.ref('users/$userId');
      await databaseRef.update({
        'preferredStore': store.location,
      });
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuPage(selectedStore: store.toMap()),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppWithSwipeBack(
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        appBar: AppBar(
          title: const Text('Select Store'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                    storeAddress: selectedStoreIndex != -1
                        ? stores[selectedStoreIndex].location
                        : 'No store selected',
                  ),
                ),
              ),
            ),
          ],
          centerTitle: true,
          backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
          elevation: 0,
        ),
        body: Stack(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
              child: FlutterMap(
                mapController: mapController,
                options: const MapOptions(
                  initialCenter: LatLng(10.8505, 76.2711),
                  initialZoom: 7.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      for (var i = 0; i < stores.length; i++)
                        Marker(
                          point: stores[i].coordinates,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => selectedStoreIndex = i);
                              mapController.move(stores[i].coordinates, 15);
                            },
                            child: Icon(
                              Icons.location_on,
                              color: colorScheme.primary,
                              size: selectedStoreIndex == i ? 48 : 40,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder: (context, scrollController) => Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.shadow.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Row(
                        children: [
                          Icon(Icons.storefront_outlined, color: colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            "Magic Coffee Stores",
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: stores.length,
                        itemBuilder: (context, index) {
                          final store = stores[index];
                          final isSelected = selectedStoreIndex == index;
                          
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            color: isSelected 
                              ? colorScheme.primaryContainer 
                              : colorScheme.surfaceContainerHighest,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected ? colorScheme.primary : Colors.transparent,
                                width: 1,
                              ),
                            ),
                            child: ListTile(
                              leading: Icon(Icons.storefront_outlined, color: colorScheme.primary),
                              title: Text(store.name, style: theme.textTheme.titleMedium),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(store.location),
                                  Row(
                                    children: [
                                      Icon(Icons.star, size: 16, color: colorScheme.primary),
                                      const SizedBox(width: 4),
                                      Text(
                                        store.rating.toString(),
                                        style: TextStyle(color: colorScheme.primary),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () => _onStoreSelected(store),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Store {
  final String name;
  final String location;
  final LatLng coordinates;
  final double rating;

  const Store({
    required this.name,
    required this.location,
    required this.coordinates,
    required this.rating,
  });

  Map<String, dynamic> toMap() => {
    'name': name,
    'location': location,
    'coordinates': coordinates,
    'rating': rating,
  };
}
