import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home/map_view_model.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: Consumer<MapViewModel>(
        builder: (context, vm, _) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Mapa"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.layers),
                  onPressed: vm.toggleMapType,
                ),
              ],
            ),
            body: GoogleMap(
              initialCameraPosition: MapViewModel.initialCameraPosition,
              mapType: vm.mapType,
              onMapCreated: vm.onMapCreated,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              markers: vm.markers,
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: vm.goToMyLocation,
              child: const Icon(Icons.my_location),
            ),
          );
        },
      ),
    );
  }
}
