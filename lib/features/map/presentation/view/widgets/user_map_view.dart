import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserMapView extends StatelessWidget {
  final LatLng userLocation;
  final MapController mapController;

  const UserMapView({
    super.key,
    required this.userLocation,
    required this.mapController,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: userLocation, initialZoom: 15),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.smart_queue',
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: userLocation,
              width: 40,
              height: 40,
              child: const Icon(
                Icons.location_history,
                color: Colors.blue,
                size: 36,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
