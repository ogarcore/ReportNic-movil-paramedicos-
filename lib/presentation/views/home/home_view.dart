import 'package:flutter/material.dart';
import '../../viewmodels/home/home_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _viewModel = HomeViewModel();
  final String userName = "Oliver";
  int _currentIndex = 0;

  // Lista de emergencias de ejemplo
  final List<Map<String, dynamic>> emergencies = [
    {
      'title': 'Incendio en edificio principal',
      'type': 'Crítica',
      'color': Color(0xFFE53935),
      'time': 'Hace 15 min',
      'status': 'Activa',
    },
    {
      'title': 'Accidente vehicular en estacionamiento',
      'type': 'Media',
      'color': Color(0xFFFFA000),
      'time': 'Hace 1 hora',
      'status': 'En proceso',
    },
    {
      'title': 'Fuga de agua en el piso 3',
      'type': 'Leve',
      'color': Color(0xFF43A047),
      'time': 'Hace 2 horas',
      'status': 'Atendida',
    },
    {
      'title': 'Persona sospechosa en área restringida',
      'type': 'Crítica',
      'color': Color(0xFFE53935),
      'time': 'Hace 30 min',
      'status': 'Activa',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(context),
      body: _buildEmergencyList(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  AppBar _buildAppBar() {
  return AppBar(
    title: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ReportNic',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontSize: 26,
            letterSpacing: 1.5
          ),
        ),
        const SizedBox(height: 4), // Espacio entre texto y logo
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 13, 106, 168).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color.fromARGB(255, 135, 128, 231).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/logo_blanco.png', // Reemplaza con la ruta de tu logo
                width: 40,
                height: 20,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ],
    ),
    backgroundColor: const Color(0xFF0D47A1),
    centerTitle: true,
    elevation: 0,
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 32, 58, 207).withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    toolbarHeight: 90, // Aumentamos la altura para acomodar el logo
    actions: [],
  );
}

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
      ),
      elevation: 20,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF0D47A1), const Color(0xFF1976D2)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerHeader(),
                  _buildDrawerItem(
                    icon: Icons.home_filled,
                    title: 'Inicio',
                    onTap: () => Navigator.pop(context),
                  ),
                  _buildDrawerItem(
                    icon: Icons.history,
                    title: 'Historial',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.analytics,
                    title: 'Estadísticas',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.settings,
                    title: 'Configuración',
                    onTap: () {},
                  ),
                  _buildDrawerItem(
                    icon: Icons.help_center,
                    title: 'Ayuda',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white54, thickness: 0.8),
            _buildDrawerItem(
              icon: Icons.logout,
              title: 'Cerrar Sesión',
              color: Colors.white,
              onTap: () => _viewModel.cerrarSesion(context),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.white, Color(0xFFBBDEFB)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                userName[0],
                style: const TextStyle(
                  fontSize: 36,
                  color: Color(0xFF0D47A1),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "usuario@reportnic.com",
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    Color? color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color ?? Colors.white, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      minLeadingWidth: 10,
    );
  }

  Widget _buildEmergencyList() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF5F9FF), Color(0xFFE3F2FD)],
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildEmergencyHeader(),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.separated(
                      itemCount: emergencies.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) => _buildEmergencyCard(emergencies[index]),
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

Widget _buildEmergencyHeader() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0D47A1),
            Color(0xFF1976D2),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Efecto de burbujas decorativas
          Positioned(
            right: 20,
            top: 10,
            child: Opacity(
              opacity: 0.2,
              child: Icon(Icons.emergency, size: 60, color: Colors.white),
            ),
          ),
          // Efecto de ondas
          Positioned(
            bottom: 0,
            left: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                width: 200,
                height: 40,
                child: CustomPaint(
                  painter: _WavePainter(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Reportes de',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'EMERGENCIAS (${emergencies.length})',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 1.5,
                        height: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 4,
                            color: Colors.black26,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

// Pintor personalizado para el efecto de ondas


  Widget _buildEmergencyCard(Map<String, dynamic> emergency) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 100,
        maxHeight: 120, // Altura fija máxima
      ),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(12),
        shadowColor: emergency['color'].withOpacity(0.6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            border: Border.all(
              color: emergency['color'].withOpacity(0.6),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: emergency['color'].withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.warning_rounded,
                        color: emergency['color'],
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            emergency['title'],
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emergency['time'],
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: emergency['color'].withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: emergency['color'].withOpacity(0.6),
                        ),
                      ),
                      child: Text(
                        emergency['type'],
                        style: TextStyle(
                          color: emergency['color'],
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(width: 34),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(emergency['status']).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getStatusColor(emergency['status']).withOpacity(0.6),
                        ),
                      ),
                      child: Text(
                        emergency['status'],
                        style: TextStyle(
                          color: _getStatusColor(emergency['status']),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'ACEPTAR',
                        style: TextStyle(
                          color: const Color(0xFF0D47A1),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Activa':
        return const Color(0xFFE53935);
      case 'En proceso':
        return const Color(0xFFFFA000);
      case 'Atendida':
        return const Color(0xFF43A047);
      default:
        return Colors.grey;
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomAppBar(
        height: 70,
        padding: EdgeInsets.zero,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.notifications,
              label: 'Alertas',
              index: 0,
            ),
            _buildNavItem(
              icon: Icons.report,
              label: 'Reportar',
              index: 1,
              isCenter: true,
            ),
            _buildNavItem(
              icon: Icons.assignment,
              label: 'Reportes',
              index: 2,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    bool isCenter = false,
  }) {
    final isSelected = _currentIndex == index;
    return IconButton(
      onPressed: () => setState(() => _currentIndex = index),
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF0D47A1) : Colors.grey,
            size: isCenter ? 28 : 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF0D47A1) : Colors.grey,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.6,
      size.width * 0.5, size.height * 0.8,
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height,
      size.width, size.height * 0.8,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}