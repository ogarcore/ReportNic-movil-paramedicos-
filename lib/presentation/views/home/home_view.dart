import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rptn_01/presentation/views/home/patient_view.dart';
import '../../viewmodels/home/audio_controls_viewmodel.dart';
import '../../viewmodels/home/home_viewmodel.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../viewmodels/menu/menu_drawer_viewmodel.dart';
import '../../widgets/audio_controls_widget.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_navbar.dart';
import '../../widgets/menu_drawer.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _viewModel = HomeViewModel();
  int _currentIndex = 1;
  void _onSend() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PatientView()),
    );
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder:
              (context) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 16,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        HugeIcons.strokeRoundedMessageQuestion,
                        size: 50,
                        color: Colors.orange[800],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '¿Estás seguro que quieres salir de ReportNic?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue[700],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              'Sí',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE3F2FD),
        body: ChangeNotifierProvider(
          create: (_) => AudioControlsViewModel()..initSpeech(),
          child: AudioControlsWidget(),
        ),
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
                colors: [
                  Color.fromARGB(255, 64, 77, 196),
                  Color.fromARGB(255, 37, 108, 201),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: FloatingActionButton(
              onPressed: () {
                _currentIndex = 1;
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                HugeIcons.strokeRoundedAlertCircle,
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
