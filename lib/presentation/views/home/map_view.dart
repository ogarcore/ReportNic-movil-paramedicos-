import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home/map_view_model.dart';
import 'package:hugeicons/hugeicons.dart';


// El widget principal se mantiene como StatelessWidget
class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MapViewModel(),
      child: Consumer<MapViewModel>(
        builder: (context, vm, _) {
          return _MapScreen(vm: vm);
        },
      ),
    );
  }
}

// ---- WIDGET CON ESTADO INTERNO ----
class _MapScreen extends StatefulWidget {
  final MapViewModel vm;

  const _MapScreen({required this.vm});

  @override
  State<_MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<_MapScreen> {
  // Estado para controlar si el panel está EXPANDIDO
  bool _isPanelExpanded = true;

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Colors.blue.shade800;
    
    // Definimos las alturas del panel para los dos estados
    final double panelHeightCollapsed = 70.0;
    final double panelHeightExpanded = MediaQuery.of(context).size.height * 0.35;

return Scaffold(
  appBar: AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            primaryColor.withOpacity(0.9),
            primaryColor.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 2),
          ),
        ],
      ),
    ),
    leading: Container(
      margin: EdgeInsets.only(left: 10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
      ),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios_new_rounded, 
          color: Colors.white,
          size: 22,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    ),
    title: Text(
      "Seleccione el Hospital Destino",
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w700,
        fontSize: 18,
        letterSpacing: 0.5,
        shadows: [
          Shadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
    ),
    centerTitle: true,
    actions: [
      Container(
        margin: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: IconButton(
          icon: Icon(
            widget.vm.isMapDark 
              ? Icons.light_mode_rounded 
              : Icons.dark_mode_rounded,
            color: Colors.white,
            size: 22,
          ),
          onPressed: widget.vm.toggleMapStyle,
          tooltip: widget.vm.isMapDark ? "Modo Claro" : "Modo Oscuro",
        ),
      ),
    ],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(15),
      ),
    ),
  ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: MapViewModel.initialCameraPosition,
            onMapCreated: widget.vm.onMapCreated,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            markers: widget.vm.markers,
            compassEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            // El padding se ajusta dinámicamente a la altura actual del panel
            padding: EdgeInsets.only(
              bottom: _isPanelExpanded ? panelHeightExpanded : panelHeightCollapsed,
            ),
          ),

          // PANEL INFERIOR CON CONTROL INTEGRADO
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              height: _isPanelExpanded ? panelHeightExpanded : panelHeightCollapsed,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isPanelExpanded = !_isPanelExpanded;
                      });
                    },

                    child: Container(
                      height: panelHeightCollapsed,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      color: Colors.transparent, 
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(HugeIcons.strokeRoundedHospital01, color: primaryColor, size: 26),
                              const SizedBox(width: 12),
                              Text(
                                "Hospitales Cercanos",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            _isPanelExpanded
                                ? Icons.keyboard_arrow_down_rounded
                                : Icons.keyboard_arrow_up_rounded,
                            size: 32,
                            color: primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ),

                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                      itemCount: widget.vm.hospitals.length,
                      itemBuilder: (context, index) {
                        final hospital = widget.vm.hospitals[index];
                        return _HospitalCard(
                          name: hospital['name'],
                          distance: hospital['distance'],
                          address: hospital['address'],
                          eta: hospital['eta'],
                          onTap: () => widget.vm.selectHospital(hospital['position']),
                          primaryColor: primaryColor,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HospitalCard extends StatelessWidget {
  final String name;
  final String distance;
  final String address;
  final String eta;
  final VoidCallback onTap;
  final Color primaryColor;

  const _HospitalCard({
    required this.name,
    required this.distance,
    required this.address,
    required this.eta,
    required this.onTap,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Material(
        borderRadius: BorderRadius.circular(14),
        elevation: 2,
        color: const Color.fromARGB(10, 255, 255, 255),
        shadowColor: primaryColor.withOpacity(0.1),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          splashColor: primaryColor.withOpacity(0.1),
          highlightColor: primaryColor.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Ícono con fondo sutil
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(0.08),
                        primaryColor.withOpacity(0.15),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    HugeIcons.strokeRoundedHospitalLocation,
                    color: primaryColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Información del hospital
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        address,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                          letterSpacing: -0.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                
                // Columna para distance (arriba) y eta (abajo)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Distance (parte superior)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedAmbulance,
                            size: 14,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            distance,
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    
                    // ETA (parte inferior)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: primaryColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            HugeIcons.strokeRoundedTime04,
                            size: 14,
                            color: primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            eta,
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}