import 'package:latlong2/latlong.dart';

class GovernmentBranch {
  final String name;
  final LatLng location;
  double? distanceInKm;

  GovernmentBranch({
    required this.name,
    required this.location,
    this.distanceInKm,
  });
}

final List<GovernmentBranch> allBranches = [
  GovernmentBranch(
    name: 'Post Office - Nasr City',
    location: LatLng(30.0601, 31.3402),
  ),
  GovernmentBranch(
    name: 'Post Office - Maadi',
    location: LatLng(29.9602, 31.2569),
  ),
  GovernmentBranch(
    name: 'Post Office - Downtown',
    location: LatLng(30.0449, 31.2359),
  ),
];
