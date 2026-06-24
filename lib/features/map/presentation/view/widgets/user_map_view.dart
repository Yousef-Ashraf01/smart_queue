import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';

class UserMapView extends StatelessWidget {
  final LatLng userLocation;
  final MapController mapController;
  final BranchModel? selectedBranch;
  final List<BranchModel> branches;
  final Function(BranchModel)? onBranchTap;

  const UserMapView({
    super.key,
    required this.userLocation,
    required this.mapController,
    this.selectedBranch,
    this.branches = const [],
    this.onBranchTap,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: mapController,
      options: MapOptions(initialCenter: userLocation, initialZoom: 15),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
          subdomains: const ['a', 'b', 'c', 'd'],
          userAgentPackageName: 'com.example.smart_queue',
        ),

        MarkerLayer(
          markers: [
            // User location marker with pulsing ring
            Marker(
              point: userLocation,
              width: 50,
              height: 50,
              child: const _PulsingUserMarker(),
            ),

            // Branch markers
            ...branches.map((branch) {
              if (branch.lat == null || branch.lng == null) return null;
              final isSelected = selectedBranch?.id == branch.id;

              return Marker(
                point: LatLng(branch.lat!, branch.lng!),
                width: isSelected ? 120 : 45,
                height: isSelected ? 80 : 45,
                child: GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      context.push(
                        AppRoutes.branchBooking,
                        extra: branch,
                      );
                    } else {
                      if (onBranchTap != null) {
                        onBranchTap!(branch);
                      }
                    }
                  },
                  child: isSelected
                      ? _SelectedBranchMarker(branch: branch)
                      : _UnselectedBranchMarker(branch: branch),
                ),
              );
            }).whereType<Marker>().toList(),
          ],
        ),
      ],
    );
  }
}

class _PulsingUserMarker extends StatefulWidget {
  const _PulsingUserMarker();

  @override
  State<_PulsingUserMarker> createState() => _PulsingUserMarkerState();
}

class _PulsingUserMarkerState extends State<_PulsingUserMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulsing ring
            Container(
              width: 45 * _controller.value,
              height: 45 * _controller.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withOpacity(0.35 * (1.0 - _controller.value)),
              ),
            ),
            // Glowing border
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            // Inner core blue dot
            Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SelectedBranchMarker extends StatefulWidget {
  final BranchModel branch;
  const _SelectedBranchMarker({required this.branch});

  @override
  State<_SelectedBranchMarker> createState() => _SelectedBranchMarkerState();
}

class _SelectedBranchMarkerState extends State<_SelectedBranchMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.teal, Color(0xFF164A27)],
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.teal.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "Book Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 3),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.tealLight,
                  size: 9,
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.teal, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.storefront_rounded,
              color: AppColors.teal,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnselectedBranchMarker extends StatelessWidget {
  final BranchModel branch;
  const _UnselectedBranchMarker({required this.branch});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Icon(
          Icons.storefront_rounded,
          color: AppColors.tealMuted,
          size: 16,
        ),
      ),
    );
  }
}

