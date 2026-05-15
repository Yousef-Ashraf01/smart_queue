import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';

class UserMapView extends StatelessWidget {
  final LatLng userLocation;
  final MapController mapController;
  final BranchModel? selectedBranch;

  const UserMapView({
    super.key,
    required this.userLocation,
    required this.mapController,
    this.selectedBranch,
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

            if (selectedBranch != null)
              Marker(
                point: LatLng(selectedBranch!.lat!, selectedBranch!.lng!),
                width: 140,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    context.push(
                      AppRoutes.branchBooking,
                      extra: selectedBranch,
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: const Text(
                          "Book Now",
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),

                      const SizedBox(height: 4),

                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
