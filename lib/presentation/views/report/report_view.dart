import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../viewmodels/menu/menu_drawer_viewmodel.dart';
import '../../viewmodels/report/report_viewmodel.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_navbar.dart';
import '../../widgets/menu_drawer.dart';
import '../home/home_view.dart';

class ReportView extends StatefulWidget {
  const ReportView({Key? key}) : super(key: key);

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final _viewModel = ReportViewModel();

  int _currentIndex = 2;

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

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
