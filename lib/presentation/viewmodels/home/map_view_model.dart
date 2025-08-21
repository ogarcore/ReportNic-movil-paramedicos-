import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'hospital_model.dart';
import 'package:rptn_01/tools/openrouteservice_api.dart';

class MapViewModel extends ChangeNotifier {
  // --- PROPIEDADES DEL VIEWMODEL ---
  String? selectedHospitalId;
  final Completer<GoogleMapController> _controllerCompleter = Completer();
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  List<Hospital> hospitals = [];
  String? _cleanMapStyle;
  bool? locationEnabled;
  bool isFetchingHospitals = false;

  // --- GETTERS PÚBLICOS ---
  Set<Marker> get markers => _markers;

  // --- CONFIGURACIÓN INICIAL DEL MAPA ---
  static const LatLng _start = LatLng(12.0795169, -86.2386964);
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: _start,
    zoom: 12,
  );

  MapViewModel() {
    _loadMapStyles();
    _checkLocationStatus();
  }

  // --- MÉTODOS DE CONFIGURACIÓN Y UTILIDADES ---

  /// Carga los estilos JSON del mapa desde los assets.
  Future<void> _loadMapStyles() async {
    _cleanMapStyle = await rootBundle.loadString(
      'assets/mapStyle/map_style_clean.json',
    );
  }

  /// Se ejecuta cuando el widget de GoogleMap ha sido creado.
  void onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (!_controllerCompleter.isCompleted) {
      _controllerCompleter.complete(controller);
    }
    _mapController?.setMapStyle(_cleanMapStyle);
  }

  /// Convierte un IconData en un BitmapDescriptor para usarlo como marcador en el mapa.
  Future<BitmapDescriptor> _getMarkerIconFromWidget({
    required IconData iconData,
    required Color color,
    required double size,
  }) async {
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
        color: color,
      ),
    );

    textPainter.layout();
    final offset = Offset(
      (size - textPainter.width) / 2,
      (size - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);

    final image = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      size.toInt(),
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);

    if (data == null) {
      return BitmapDescriptor.defaultMarker;
    }

    return BitmapDescriptor.fromBytes(data.buffer.asUint8List());
  }

  // --- LÓGICA PRINCIPAL DE UBICACIÓN Y HOSPITALES ---

  /// Verifica los permisos y el estado del servicio de ubicación al iniciar.
  Future<void> _checkLocationStatus() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    final permission = await Geolocator.checkPermission();
    locationEnabled =
        serviceEnabled &&
        (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse);
    notifyListeners();
    if (locationEnabled == true) {
      await goToMyLocation();
    }
  }

  /// Obtiene la ubicación actual del usuario, la centra en el mapa y busca hospitales cercanos.
  Future<void> goToMyLocation() async {
    try {
      final pos = await Geolocator.getCurrentPosition();
      final latLng = LatLng(pos.latitude, pos.longitude);

      final userIcon = await _getMarkerIconFromWidget(
        iconData: HugeIcons.strokeRoundedAmbulance,
        color: Colors.blue.shade800,
        size: 100.0,
      );

      _markers.removeWhere((m) => m.markerId.value == 'yo');
      _markers.add(
        Marker(
          markerId: const MarkerId("yo"),
          position: latLng,
          icon: userIcon,
          infoWindow: const InfoWindow(title: "Mi Ubicación"),
        ),
      );

      locationEnabled = true;
      notifyListeners();

      await _fetchAndProcessHospitals(pos);

      final GoogleMapController controller = await _controllerCompleter.future;
      controller.animateCamera(CameraUpdate.newLatLngZoom(latLng, 15));
    } catch (e) {
      // Manejar error si no se puede obtener la ubicación.
      locationEnabled = false;
      notifyListeners();
    }
  }

  /// Obtiene los hospitales de Firestore, calcula rutas y los procesa para mostrarlos.
  Future<void> _fetchAndProcessHospitals(Position userPosition) async {
    if (isFetchingHospitals) return;

    isFetchingHospitals = true;
    notifyListeners();

    final querySnapshot =
        await FirebaseFirestore.instance
            .collection('hospitales_reportnic')
            .get();
    List<Hospital> processedHospitals = [];

    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      final hospitalPosition = LatLng(
        (data['latitude'] as num).toDouble(),
        (data['longitude'] as num).toDouble(),
      );

      final distanceInMeters = Geolocator.distanceBetween(
        userPosition.latitude,
        userPosition.longitude,
        hospitalPosition.latitude,
        hospitalPosition.longitude,
      );
      if (distanceInMeters / 1000 > 6.0) {
        continue;
      }

      String routeDistance = 'N/A';
      String routeDuration = 'N/A';
      double distanceForSort = distanceInMeters / 1000;

      try {
        final List<List<double>> coordinates = [
          [userPosition.longitude, userPosition.latitude],
          [hospitalPosition.longitude, hospitalPosition.latitude],
        ];

        final directions = await OpenRouteServiceApi().getDirections(
          coordinates: coordinates,
        );

        if (directions?.routes?.isNotEmpty ?? false) {
          final summary = directions!.routes!.first.summary;
          if (summary != null) {
            distanceForSort = summary.distance / 1000;
            routeDistance = '${distanceForSort.toStringAsFixed(1)} km';

            final int horaActual = DateTime.now().hour;
            double factorCongestion =
                (horaActual == 7 || horaActual == 17) ? 1.6 : 1.2;
            const double tiempoBaseAdicionalSegundos = 50.0;

            final duracionConCongestion =
                (summary.duration * factorCongestion) +
                tiempoBaseAdicionalSegundos;
            final durationInMinutes = (duracionConCongestion / 60).round();
            routeDuration = '$durationInMinutes min. aprox.';
          }
        }
      } catch (e) {
        /* Ignorar si falla */
      }

      String address = 'Dirección no disponible';
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          hospitalPosition.latitude,
          hospitalPosition.longitude,
        );
        if (placemarks.isNotEmpty) {
          final place = placemarks.first;
          address = "${place.street ?? ''}, ${place.locality ?? ''}".replaceAll(
            RegExp(r'^, |,$'),
            '',
          );
        }
      } catch (e) {
        /* Ignorar error */
      }

      processedHospitals.add(
        Hospital(
          id: doc.id,
          name: data['name'] ?? 'Nombre no disponible',
          position: hospitalPosition,
          address: address,
          distanceInKm: distanceForSort,
          distance: routeDistance,
          eta: routeDuration,
        ),
      );
    }

    processedHospitals.sort((a, b) => a.distanceInKm.compareTo(b.distanceInKm));
    hospitals = processedHospitals;

    isFetchingHospitals = false;
    notifyListeners();
  }

  // --- MÉTODOS DE INTERACCIÓN DE LA UI ---

  Future<void> selectHospital(LatLng hospitalPosition) async {
    _markers.removeWhere((m) => m.markerId.value.startsWith("hospital_"));
    final hospitalIcon = await _getMarkerIconFromWidget(
      iconData: HugeIcons.strokeRoundedHospitalLocation,
      color: Colors.red.shade700,
      size: 110.0,
    );

    _markers.add(
      Marker(
        markerId: MarkerId(
          "hospital_${hospitalPosition.latitude}_${hospitalPosition.longitude}",
        ),
        position: hospitalPosition,
        icon: hospitalIcon,
        infoWindow: const InfoWindow(title: "Hospital Seleccionado"),
      ),
    );
    notifyListeners();
    LatLng? userPosition;
    try {
      userPosition =
          _markers.firstWhere((m) => m.markerId.value == 'yo').position;
    } catch (e) {
      final GoogleMapController controller = await _controllerCompleter.future;
      controller.animateCamera(
        CameraUpdate.newLatLngZoom(hospitalPosition, 15),
      );
      return;
    }

    final LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
        userPosition.latitude < hospitalPosition.latitude
            ? userPosition.latitude
            : hospitalPosition.latitude,
        userPosition.longitude < hospitalPosition.longitude
            ? userPosition.longitude
            : hospitalPosition.longitude,
      ),
      northeast: LatLng(
        userPosition.latitude > hospitalPosition.latitude
            ? userPosition.latitude
            : hospitalPosition.latitude,
        userPosition.longitude > hospitalPosition.longitude
            ? userPosition.longitude
            : hospitalPosition.longitude,
      ),
    );

    final GoogleMapController controller = await _controllerCompleter.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 80.0));
  }

  void setHospitalForConfirmation(String hospitalId) {
    selectedHospitalId = hospitalId;
    // No necesitamos notificar a los listeners aquí, solo es guardar el dato.
  }
}
