import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; // Necesario para cargar el JSON
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapViewModel extends ChangeNotifier {
  GoogleMapController? _controller;
  final Set<Marker> _markers = {};
  
  // Estado para controlar el modo oscuro del mapa
  bool _isMapDark = false;
  bool get isMapDark => _isMapDark;

  String? _darkMapStyle;

  Set<Marker> get markers => _markers;

  static const LatLng _start = LatLng(12.0795169, -86.2386964); // Managua
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: _start,
    zoom: 12,
  );

  MapViewModel() {
    _loadMapStyles(); 
  }

  // Método para cargar el JSON del estilo del mapa
  Future<void> _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/mapStyle/map_style_dark.json');
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    if (_isMapDark) {
      _controller?.setMapStyle(_darkMapStyle);
    }
    // Opcional: Centrar en la ubicación del usuario al iniciar el mapa
    goToMyLocation(); 
  }

  Future<void> goToMyLocation() async {
    final hasPermission = await _handlePermission();
    if (!hasPermission) return;

    final pos = await Geolocator.getCurrentPosition();
    final latLng = LatLng(pos.latitude, pos.longitude);

    _markers.add(
      Marker(
        markerId: const MarkerId("yo"),
        position: latLng,
        infoWindow: const InfoWindow(title: "Mi Ubicación"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
      ),
    );
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

  // Nueva función para alternar entre modo claro y oscuro
  void toggleMapStyle() {
    _isMapDark = !_isMapDark;
    if (_isMapDark) {
      _controller?.setMapStyle(_darkMapStyle);
    } else {
      _controller?.setMapStyle(null); // null para volver al estilo por defecto
    }
    notifyListeners();
  }

  void selectHospital(LatLng position) {
    // Podríamos limpiar otros marcadores de hospitales si queremos solo uno a la vez
    _markers.removeWhere((m) => m.markerId.value.startsWith("hospital_"));

    _markers.add(
      Marker(
        markerId: MarkerId("hospital_${position.latitude}"),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: "Hospital seleccionado"),
      ),
    );

    _controller?.animateCamera(CameraUpdate.newLatLngZoom(position, 15));
    notifyListeners();
  }

  // Lista de hospitales (sin cambios)
  List<Map<String, dynamic>> get hospitals => [
    {
      'name': 'Hospital Metropolitano',
      'distance': '2.5 km',
      'address': 'Carretera Masaya, Managua',
      'position': const LatLng(12.1286, -86.2536),
      'eta': '10 min. aprox.',
    },
    {
      'name': 'Hospital Bautista',
      'distance': '3.1 km',
      'address': 'Reparto Serrano, Managua',
      'position': const LatLng(12.1324, -86.2678),
      'eta': '15 min. aprox.',
    },
    {
      'name': 'Hospital Militar',
      'distance': '4.7 km',
      'address': 'Avenida Universitaria, Managua',
      'position': const LatLng(12.1412, -86.2387),
      'eta': '10 min. aprox.',
    },
    {
      'name': 'Hospital Vélez Paiz',
      'distance': '5.2 km',
      'address': 'Sector Sur, Managua',
      'position': const LatLng(12.1218, -86.2453),
      'eta': '10 min. aprox.',
    },
  ];
}