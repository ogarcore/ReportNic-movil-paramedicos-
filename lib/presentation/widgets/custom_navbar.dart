import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../views/alerts/alert_view.dart';
import '../views/report/report_view.dart';

class CustomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  _CustomNavBarState createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
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
        height: 72,
        padding: EdgeInsets.zero,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 12.5,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: HugeIcons.strokeRoundedNotification03,
                  label: 'Alertas',
                  index: 0,
                  view: const AlertView(),
                ),
                const SizedBox(width: 0),
                _buildNavItem(
                  icon: HugeIcons.strokeRoundedAnalysisTextLink,
                  label: 'Reportes',
                  index: 2,
                  view: const ReportView(),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 7,
              child: Column(
                children: [
                  Text(
                    'Reportar',
                    style: TextStyle(
                      color:
                          widget.currentIndex == 1
                              ? const Color(0xFF0D47A1)
                              : Colors.grey,
                      fontSize: 12,
                      fontWeight:
                          widget.currentIndex == 1
                              ? FontWeight.w600
                              : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (widget.currentIndex == 1)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D47A1),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
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
    required Widget view,
  }) {
    final isSelected = widget.currentIndex == index;

    return IconButton(
      onPressed: () {
        if (widget.currentIndex != index) {
          widget.onTabSelected(index);
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => view,
              transitionsBuilder: (
                context,
                animation,
                secondaryAnimation,
                child,
              ) {
                const begin = 0.0;
                const end = 1.0;
                const curve = Curves.easeInOut;

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
              ), // Más rápido
            ),
          );
        }
      },
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isSelected ? const Color(0xFF0D47A1) : Colors.grey,
            size: 24,
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
          const SizedBox(height: 4),
          if (isSelected)
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
