import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:smart_queue/core/di/service_locator.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/styling/app_styles.dart';
import 'package:smart_queue/features/home/data/models/organization_model.dart';
import 'package:smart_queue/features/home/presentation/cubit/organization_cubit.dart';
import 'package:smart_queue/features/map/data/models/branch_model.dart';
import 'package:smart_queue/features/map/data/repositories/branch_repository.dart';

class LiveBranchesMapCarousel extends StatefulWidget {
  const LiveBranchesMapCarousel({super.key});

  @override
  State<LiveBranchesMapCarousel> createState() =>
      _LiveBranchesMapCarouselState();
}

class _LiveBranchesMapCarouselState extends State<LiveBranchesMapCarousel> {
  LatLng? _userLocation;
  bool _isLoadingLocation = true;
  int? _selectedOrgId;
  String? _selectedOrgName;
  bool _isLoadingBranches = false;
  List<BranchModel> _allBranches = [];
  String? _branchesError;
  late final MapController _mapController;
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _activeCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getUserLocation();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _isLoadingLocation = false;
              _userLocation = const LatLng(30.0444, 31.2357);
            });
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
            _userLocation = const LatLng(30.0444, 31.2357);
          });
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      if (mounted) {
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
          _userLocation = const LatLng(30.0444, 31.2357);
        });
      }
    }
  }

  Future<void> _fetchBranchesForSelected(int orgId) async {
    if (!mounted) return;
    setState(() {
      _isLoadingBranches = true;
      _branchesError = null;
    });

    try {
      final repository = sl<BranchRepository>();
      final result = await repository.getBranches(orgId);

      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _branchesError = failure.message;
              _isLoadingBranches = false;
            });
          }
        },
        (branchesList) {
          if (mounted) {
            setState(() {
              _allBranches = branchesList;
              _isLoadingBranches = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _branchesError = e.toString();
          _isLoadingBranches = false;
        });
      }
    }
  }

  double _calculateDistance(double destLat, double destLng) {
    if (_userLocation == null) return 0.0;
    final meters = Geolocator.distanceBetween(
      _userLocation!.latitude,
      _userLocation!.longitude,
      destLat,
      destLng,
    );
    return meters / 1000;
  }

  @override
  Widget build(BuildContext context) {
    final orgState = context.watch<OrganizationsCubit>().state;
    if (orgState is OrganizationsLoaded && orgState.organizations.isNotEmpty) {
      if (_selectedOrgId == null) {
        final firstOrg = orgState.organizations.first;
        _selectedOrgId = firstOrg.id;
        _selectedOrgName = firstOrg.name.localizedApi;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _fetchBranchesForSelected(firstOrg.id);
        });
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'nearby_branches_for'.tr(args: [_selectedOrgName ?? '']),
          style: AppStyle.bold16black,
        ),
        const SizedBox(height: 16),

        if (orgState is OrganizationsLoaded)
          _buildOrganizationSelector(orgState.organizations),
        if (orgState is OrganizationsLoaded) const SizedBox(height: 16),

        _buildContent(orgState),
      ],
    );
  }

  Widget _buildOrganizationSelector(List<OrganizationModel> organizations) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: organizations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final org = organizations[index];
          final isSelected = org.id == _selectedOrgId;
          return GestureDetector(
            onTap: () {
              if (org.id != _selectedOrgId) {
                setState(() {
                  _selectedOrgId = org.id;
                  _selectedOrgName = org.name.localizedApi;
                  _activeCardIndex = 0;
                });
                _fetchBranchesForSelected(org.id);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1A9E7A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color:
                      isSelected
                          ? const Color(0xFF1A9E7A)
                          : Colors.grey.shade300,
                ),
              ),
              child: Text(
                org.name.localizedApi,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(OrganizationState orgState) {
    if (_isLoadingLocation ||
        _isLoadingBranches ||
        orgState is OrganizationsLoading) {
      return _buildSkeletonLoader();
    }

    if (_branchesError != null) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        child: Text(
          'error_loading_branches'.tr(args: [_branchesError ?? '']),
          style: TextStyle(color: Colors.red.shade600),
        ),
      );
    }

    final List<BranchModel> branches =
        _allBranches.where((b) => b.lat != null && b.lng != null).map((b) {
            final dist = _calculateDistance(b.lat!, b.lng!);
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
              distanceInKm: dist,
              operatingHours: b.operatingHours,
            );
          }).toList()
          ..sort(
            (a, b) => (a.distanceInKm ?? 0).compareTo(b.distanceInKm ?? 0),
          );

    if (branches.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.location_off_rounded,
                size: 28,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'no_branches_found'.tr(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "no_registered_branches_area".tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 14,
                    color: Colors.grey.shade500,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'try_another_organization'.tr(),
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _userLocation ?? const LatLng(30.0444, 31.2357),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.smartqueue.app',
                ),
                MarkerLayer(
                  markers: [
                    if (_userLocation != null)
                      Marker(
                        point: _userLocation!,
                        width: 32,
                        height: 32,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF1A9E7A,
                                ).withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Color(0xFF1A9E7A),
                                shape: BoxShape.circle,
                                border: Border.fromBorderSide(
                                  BorderSide(color: Colors.white, width: 2),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ...branches.map((b) {
                      final isSelected =
                          branches.indexOf(b) == _activeCardIndex;
                      return Marker(
                        point: LatLng(b.lat!, b.lng!),
                        width: 36,
                        height: 36,
                        child: GestureDetector(
                          onTap: () {
                            final idx = branches.indexOf(b);
                            _pageController.animateToPage(
                              idx,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Icon(
                            Icons.location_on_rounded,
                            color:
                                isSelected
                                    ? const Color(0xFFFB8C00)
                                    : const Color(0xFF0D7355),
                            size: isSelected ? 34 : 26,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        SizedBox(
          height: 154,
          child: PageView.builder(
            controller: _pageController,
            itemCount: branches.length,
            onPageChanged: (index) {
              setState(() => _activeCardIndex = index);
              final b = branches[index];
              _mapController.move(LatLng(b.lat! - 0.003, b.lng!), 14.5);
            },
            itemBuilder: (context, index) {
              final branch = branches[index];
              return _buildBranchCard(branch);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBranchCard(BranchModel branch) {
    final bid = branch.id ?? 1;
    final String trafficText;
    final Color trafficColor;
    final Color trafficBg;
    final String waitTime;

    if (bid % 3 == 0) {
      trafficText = 'low_traffic'.tr();
      trafficColor = const Color(0xFF2ECC71);
      trafficBg = const Color(0xFFE8F5E9);
      waitTime = 'wait_mins'.tr(args: ['5']);
    } else if (bid % 3 == 1) {
      trafficText = 'moderate_traffic'.tr();
      trafficColor = const Color(0xFFFB8C00);
      trafficBg = const Color(0xFFFFF3E0);
      waitTime = 'wait_mins'.tr(args: ['20']);
    } else {
      trafficText = 'busy_traffic'.tr();
      trafficColor = Colors.red.shade700;
      trafficBg = Colors.red.shade50;
      waitTime = 'wait_mins'.tr(args: ['45']);
    }

    final dist =
        branch.distanceInKm != null
            ? 'km_away'.tr(args: [branch.distanceInKm!.toStringAsFixed(1)])
            : '';

    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name.localizedApi,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2D3436),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dist,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: trafficBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  trafficText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: trafficColor,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'estimated_wait_short'.tr(),
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                  Text(
                    waitTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A9E7A),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  context.push(AppRoutes.branchBooking, extra: branch);
                },
                child: Row(
                  children: [
                    Text(
                      'book_btn'.tr(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 10),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SkeletonBox(width: 220, height: 18),
        const SizedBox(height: 16),

        Row(
          children: [
            _SkeletonBox(width: 90, height: 34, radius: 20),
            const SizedBox(width: 8),
            _SkeletonBox(width: 110, height: 34, radius: 20),
            const SizedBox(width: 8),
            _SkeletonBox(width: 80, height: 34, radius: 20),
          ],
        ),
        const SizedBox(height: 16),

        _SkeletonBox(width: double.infinity, height: 160, radius: 24),
        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(width: 140, height: 14),
                      const SizedBox(height: 6),
                      _SkeletonBox(width: 80, height: 11),
                    ],
                  ),
                  _SkeletonBox(width: 72, height: 24, radius: 10),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBox(width: 70, height: 10),
                      const SizedBox(height: 6),
                      _SkeletonBox(width: 55, height: 18),
                    ],
                  ),
                  _SkeletonBox(width: 80, height: 36, radius: 14),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  State<_SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<_SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _animation = Tween<double>(
      begin: -1,
      end: 2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              colors: const [
                Color(0xFFE8F5E9),
                Color(0xFFC8EAD8),
                Color(0xFFE8F5E9),
              ],
            ),
          ),
        );
      },
    );
  }
}
