import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_queue/features/map/data/models/government_branch.dart';
import 'package:smart_queue/features/map/presentation/view/widgets/branches_bottom_sheet.dart';
import 'package:smart_queue/features/map/presentation/view/widgets/user_map_view.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;
  bool isLoading = true;
  String? error;

  late final MapController mapController;
  List<GovernmentBranch> nearbyBranches = [];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userLocation = LatLng(position.latitude, position.longitude);
      _filterNearbyBranches();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterNearbyBranches() {
    nearbyBranches =
        allBranches
            .map((branch) {
              final meters = Geolocator.distanceBetween(
                userLocation!.latitude,
                userLocation!.longitude,
                branch.location.latitude,
                branch.location.longitude,
              );

              return GovernmentBranch(
                name: branch.name,
                location: branch.location,
                distanceInKm: meters / 1000,
              );
            })
            .where((branch) => branch.distanceInKm! <= 500)
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Colors.green[200]),
        ),
      );
    }

    if (error != null) {
      return Scaffold(body: Center(child: Text(error!)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Choose Branch')),
      body: Stack(
        children: [
          UserMapView(
            userLocation: userLocation!,
            mapController: mapController,
          ),
          BranchesBottomSheet(branches: nearbyBranches),
        ],
      ),
    );
  }
}

class BranchBookingScreen extends StatelessWidget {
  final GovernmentBranch branch;

  const BranchBookingScreen({super.key, required this.branch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(branch.name)),
      body: const Center(child: Text('Booking UI here')),
    );
  }
}
