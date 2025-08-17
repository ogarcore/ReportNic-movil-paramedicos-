import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapViewModel extends ChangeNotifier {
  GoogleMapController? _controller;
  MapType _mapType = MapType.normal;
  final Set<Marker> _markers = {};

  MapType get mapType => _mapType;
  Set<Marker> get markers => _markers;

  static const LatLng _start = LatLng(12.136389, -86.251389); // Managua
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: _start,
    zoom: 12,
  );

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> goToMyLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    final pos = await Geolocator.getCurrentPosition();
    final latLng = LatLng(pos.latitude, pos.longitude);

    _markers.add(Marker(
      markerId: const MarkerId("yo"),
      position: latLng,
      infoWindow: const InfoWindow(title: "Estoy aquí"),
    ));
    notifyListeners();

    _controller?.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return false;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) return false;

    return true;
  }

  void toggleMapType() {
    _mapType = (_mapType == MapType.normal) ? MapType.hybrid : MapType.normal;
    notifyListeners();
  }
}
