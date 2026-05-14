import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
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
      appBar: AppBar(
        title: const Text('Choose Branch'),
        surfaceTintColor: AppColors.white,
        backgroundColor: AppColors.white,
      ),
      body: BlocBuilder<BranchCubit, BranchState>(
        bloc: cubit,
        builder: (context, state) {
          if (state is BranchLoading) {
            return Center(
              child: CircularProgressIndicator(color: Colors.green[200]),
            );
          }

          if (state is BranchError) {
            return Center(child: Text(state.message));
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
                ),

                Positioned(
                  top: 20,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      onChanged: _searchBranches,
                      cursorColor: Colors.green[200],
                      decoration: const InputDecoration(
                        hintText: "Search branches...",
                        border: InputBorder.none,
                        icon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),

                BranchesBottomSheet(
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
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
