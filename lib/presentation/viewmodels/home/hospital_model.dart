import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hospital {
  final String id;
  final String name;
  final LatLng position;
  final String address;
  final double distanceInKm; 
  final String distance; 
  final String eta;

  Hospital({
    required this.id,
    required this.name,
    required this.position,
    required this.address,
    required this.distanceInKm,
    required this.distance, 
    required this.eta,
  });
}