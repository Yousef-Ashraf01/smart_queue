import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_queue/core/styling/app_colors.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:smart_queue/features/map/presentation/cubit/branch_cubit.dart';
import 'package:smart_queue/features/map/presentation/view/widgets/branches_bottom_sheet.dart';
import 'package:smart_queue/features/map/presentation/view/widgets/user_map_view.dart';

import '../../../../core/di/service_locator.dart';

class MapScreen extends StatefulWidget {
  final int organizationId;

  const MapScreen({super.key, required this.organizationId});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? userLocation;
  bool isLoading = true;
  String? error;
  late BranchCubit cubit;

  late final MapController mapController;
  List<BranchModel> nearbyBranches = [];

  TextEditingController searchController = TextEditingController();
  List<BranchModel> filteredBranches = [];
  bool isInitialized = false;

  BranchModel? selectedBranch;

  @override
  void initState() {
    super.initState();
    cubit = sl<BranchCubit>();
    cubit.fetchBranches(widget.organizationId);
    mapController = MapController();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            error = "Location permission denied by user.";
            isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          error =
              "Location permission denied permanently. Please enable it from settings.";
          isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      userLocation = LatLng(position.latitude, position.longitude);

      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterNearbyBranches(List branchesFromApi) {
    nearbyBranches =
        branchesFromApi
            .where((b) => b.lat != null && b.lng != null)
            .map((b) {
              final meters = Geolocator.distanceBetween(
                userLocation!.latitude,
                userLocation!.longitude,
                b.lat!,
                b.lng!,
              );

              return BranchModel(
                id: b.id,
                organizationId: b.organizationId,
                name: b.name,
                email: b.email,
                phone: b.phone,
                isActive: b.isActive,
                lat: b.lat,
                lng: b.lng,
                address: b.address,
                city: b.city,
                country: b.country,
                postalCode: b.postalCode,
                distanceInKm: meters / 1000,
                operatingHours: b.operatingHours,
              );
            })
            .where((branch) => branch.distanceInKm! <= 100)
            .toList()
          ..sort((a, b) => a.distanceInKm!.compareTo(b.distanceInKm!));

    filteredBranches = List.from(nearbyBranches);
  }

  void _searchBranches(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredBranches = List.from(nearbyBranches);
      });
      return;
    }

    setState(() {
      filteredBranches =
          nearbyBranches.where((branch) {
            return branch.name.toLowerCase().contains(query.toLowerCase()) ||
                (branch.address ?? "").toLowerCase().contains(
                  query.toLowerCase(),
                );
          }).toList();
    });
  }

  void _retry() {
    setState(() {
      isLoading = true;
      error = null;
      isInitialized = false;
      selectedBranch = null;
    });
    cubit.fetchBranches(widget.organizationId);
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _MapScreenLoadingView();
    }

    if (error != null) {
      return _MapErrorView(message: error!, onRetry: _retry);
    }

    return Scaffold(
      body: BlocBuilder<BranchCubit, BranchState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is BranchLoading) {
            return const _MapScreenLoadingView();
          }

          if (state is BranchError) {
            return _MapErrorView(message: state.message, onRetry: _retry);
          }

          if (state is BranchLoaded) {
            if (!isInitialized) {
              _filterNearbyBranches(state.branches);
              isInitialized = true;
            }

            return Stack(
              children: [
                UserMapView(
                  userLocation: userLocation!,
                  mapController: mapController,
                  selectedBranch: selectedBranch,
                  branches: filteredBranches,
                  onBranchTap: (branch) {
                    setState(() {
                      selectedBranch = branch;
                    });

                    mapController.move(
                      LatLng(branch.lat! - 0.002, branch.lng!),
                      16,
                    );
                  },
                ),

                // Floating App Bar and Search Input
                Positioned(
                  top: MediaQuery.of(context).padding.top + 12,
                  left: 16,
                  right: 16,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.teal,
                            size: 20,
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.95),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.6),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: searchController,
                            onChanged: _searchBranches,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: 'Inter Tight',
                              fontWeight: FontWeight.w500,
                            ),
                            cursorColor: AppColors.teal,
                            decoration: InputDecoration(
                              hintText: "Search nearby branches...",
                              hintStyle: TextStyle(color: Colors.grey.shade500),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.teal,
                                size: 22,
                              ),
                              suffixIcon:
                                  searchController.text.isNotEmpty
                                      ? IconButton(
                                        icon: const Icon(
                                          Icons.clear_rounded,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          searchController.clear();
                                          _searchBranches('');
                                        },
                                      )
                                      : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Floating My Location Button
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.38 + 24,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: () {
                      if (userLocation != null) {
                        mapController.move(userLocation!, 15);
                      }
                    },
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.teal,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.my_location_rounded),
                  ),
                ),

                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: BranchesBottomSheet(
                    branches: filteredBranches,
                    selectedBranch: selectedBranch,
                    onBranchTap: (branch) {
                      setState(() {
                        selectedBranch = branch;
                      });

                      mapController.move(
                        LatLng(branch.lat! - 0.002, branch.lng!),
                        16,
                      );
                    },
                    onCloseDetails: () {
                      setState(() {
                        selectedBranch = null;
                      });
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _MapScreenLoadingView extends StatelessWidget {
  const _MapScreenLoadingView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background grid simulating map
          Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            highlightColor: Colors.grey[50]!,
            child: Container(
              color: Colors.white,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                ),
                itemBuilder:
                    (context, index) => Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[100]!,
                          width: 0.5,
                        ),
                      ),
                    ),
              ),
            ),
          ),
          // Pulsing radar animation
          Center(child: _LoadingRadarAnimation()),
          // Bottom sheet skeleton
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.38,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      width: 150,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 2,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder:
                            (context, index) => Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingRadarAnimation extends StatefulWidget {
  @override
  State<_LoadingRadarAnimation> createState() => _LoadingRadarAnimationState();
}

class _LoadingRadarAnimationState extends State<_LoadingRadarAnimation>
    with SingleTickerProviderStateMixin {
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
          children: List.generate(3, (index) {
            final delay = index * 0.33;
            final progress = (_controller.value - delay) % 1.0;
            return Container(
              width: 150 * progress,
              height: 150 * progress,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.teal.withOpacity(0.15 * (1.0 - progress)),
              ),
            );
          })..add(
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: const Center(
                child: SizedBox(
                  width: 10,
                  height: 10,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.teal),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MapErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _MapErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_off_rounded,
                  size: 64,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Access Denied or Error",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
