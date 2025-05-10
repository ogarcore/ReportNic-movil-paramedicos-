import 'package:flutter/material.dart';
import '../../viewmodels/alerts/alert_viewmodel.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../viewmodels/menu/menu_drawer_viewmodel.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_navbar.dart';
import '../../widgets/emergencies_list.dart';
import '../../widgets/menu_drawer.dart';
import '../home/home_view.dart';

class AlertView extends StatefulWidget {
  const AlertView({Key? key}) : super(key: key);

  @override
  State<AlertView> createState() => _AlertViewState();
}

class _AlertViewState extends State<AlertView> {
  final _viewModel = AlertViewModel();
  int _currentIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder:
                (context, animation, secondaryAnimation) => const HomeView(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              const begin = 0.0;
              const end = 1.0;
              const curve = Curves.easeInOutQuad;
              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(CurveTween(curve: curve));
              return FadeTransition(
                opacity: animation.drive(tween),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 200),
          ),
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xFFE3F2FD),
        appBar: const CustomAppBar(
          title: 'ReportNic',
          logoPath: 'assets/images/logo_blanco.png',
        ),
        drawer: MenuDrawer(
          onLogout: () => _viewModel.cerrarSesion(context),
          onHome: () {},
          onHistory: () {},
          onStatistics: () {},
          onSettings: () {},
          onHelp: () {},
          viewModel: MenuDrawerViewModel(),
        ),
        body: EmergenciesList(emergencies: emergencies),
        bottomNavigationBar: CustomNavBar(
          currentIndex: _currentIndex,
          onTabSelected: _onTabSelected,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Transform.translate(
          offset: const Offset(0, 6),
          child: Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const LinearGradient(
                colors: [Color(0xFFB71C1C), Color(0xFFD32F2F)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  PageRouteBuilder(
                    pageBuilder:
                        (context, animation, secondaryAnimation) =>
                            const HomeView(),
                    transitionsBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) {
                      const begin =
                          0.0; // Opacidad inicial (completamente transparente)
                      const end = 1.0; // Opacidad final (completamente visible)
                      const curve =
                          Curves.easeInOutQuad; // Curva de animación más suave

                      var tween = Tween(
                        begin: begin,
                        end: end,
                      ).chain(CurveTween(curve: curve));

                      return FadeTransition(
                        opacity: animation.drive(tween),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(
                      milliseconds: 200,
                    ), // Más rápido que el default
                  ),
                );
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedMic01,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
