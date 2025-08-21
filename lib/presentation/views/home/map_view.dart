import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home/map_view_model.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:shimmer/shimmer.dart';
import 'confirmation_view.dart';

// El widget MapView principal no necesita cambios
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

// El widget _MapScreen no necesita cambios en su lógica de estado
class _MapScreen extends StatefulWidget {
  final MapViewModel vm;
  const _MapScreen({required this.vm});

  @override
  State<_MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<_MapScreen> {
  bool _isPanelExpanded = false;

  @override
  void initState() {
    super.initState();
    _isPanelExpanded = widget.vm.locationEnabled ?? false;
    widget.vm.addListener(_onViewModelUpdated);
  }

  void _onViewModelUpdated() {
    if (mounted && widget.vm.locationEnabled != null) {
      if (_isPanelExpanded != widget.vm.locationEnabled) {
        setState(() {
          _isPanelExpanded = widget.vm.locationEnabled!;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.vm.removeListener(_onViewModelUpdated);
    super.dispose();
  }

  void _showConfirmationDialog(BuildContext context, hospital) {
  final vm = Provider.of<MapViewModel>(context, listen: false);
  final primaryColor = Colors.blue.shade800;
  final gradientColors = [
    primaryColor.withOpacity(0.9),
    primaryColor.withOpacity(0.7),
  ];

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext dialogContext) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        elevation: 20,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icono decorativo
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Título
              Text(
                'Confirmar Destino',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Mensaje
              Text(
                '¿Estás seguro de seleccionar el\n"${hospital.name}"?',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón Cancelar
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey[300]!),
                        backgroundColor: Colors.grey[50],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                      },
                      child: const Text(
                        'Cancelar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Botón Aceptar
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        shadowColor: primaryColor.withOpacity(0.3),
                      ),
                      onPressed: () {
                        vm.setHospitalForConfirmation(hospital.id);
                        Navigator.of(dialogContext).pop();
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ConfirmationView(
                              hospitalId: vm.selectedHospitalId!,
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Confirmar',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    final vm = widget.vm;
    final Color primaryColor = Colors.blue.shade800;

    final double panelHeightCollapsed = 70.0;
    final double panelHeightExpanded =
        MediaQuery.of(context).size.height * 0.35;

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
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.2),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
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
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
        centerTitle: true,
        actions: [],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
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
            padding: EdgeInsets.only(
              bottom:
                  _isPanelExpanded ? panelHeightExpanded : panelHeightCollapsed,
            ),
          ),
          if (vm.locationEnabled == null)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              ),
            )
          else if (vm.locationEnabled == false)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_off,
                        color: Colors.white,
                        size: 50,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "La ubicación está desactivada",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          await vm.goToMyLocation();
                        },
                        child: const Text(
                          "Activar ubicación",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
              height:
                  _isPanelExpanded ? panelHeightExpanded : panelHeightCollapsed,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
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
                      if (vm.locationEnabled == true) {
                        setState(() {
                          _isPanelExpanded = !_isPanelExpanded;
                        });
                      }
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
                              Icon(
                                HugeIcons.strokeRoundedHospital01,
                                color: primaryColor,
                                size: 26,
                              ),
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
                          if (vm.locationEnabled == true)
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
                    // --> CAMBIO: Usamos un widget condicional para mostrar el Shimmer o la lista.
                    child:
                        vm.isFetchingHospitals
                            ? const _HospitalListShimmer() // Muestra el efecto Shimmer
                            : ListView.builder(
                              // Muestra la lista real cuando termina la carga
                              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                              itemCount: vm.hospitals.length,
                              itemBuilder: (context, index) {
                                final hospital = vm.hospitals[index];
                                return _HospitalCard(
                                  name: hospital.name,
                                  distance: hospital.distance,
                                  eta: hospital.eta,
                                  onTap: () {
                                    vm.selectHospital(hospital.position);
                                    _showConfirmationDialog(context, hospital);
                                  },
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

// --- WIDGET DE TARJETA DE HOSPITAL (CON CORRECCIONES) ---

class _HospitalCard extends StatelessWidget {
  final String name;
  final String distance;
  final String eta;
  final VoidCallback onTap;
  final Color primaryColor;

  const _HospitalCard({
    required this.name,
    required this.distance,
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
            padding: const EdgeInsets.all(
              12.0,
            ), // Aumentamos un poco el padding
            child: Row(
              // --> CAMBIO: Centramos verticalmente el contenido
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
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
                // --> CAMBIO: El Expanded ahora solo contiene el nombre
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 16, // Aumentamos un poco el tamaño de fuente
                      letterSpacing: -0.2,
                    ),
                    maxLines:
                        3, // Permitimos hasta 3 líneas para nombres muy largos
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // La columna de distancia y tiempo se mantiene igual
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize:
                      MainAxisSize.min, // Para que no ocupe espacio extra
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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

class _HospitalListShimmer extends StatelessWidget {
  const _HospitalListShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        itemCount: 4, // Muestra 4 tarjetas de esqueleto
        itemBuilder:
            (_, __) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 42.0,
                    height: 42.0,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      height: 20.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 60.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 50.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
