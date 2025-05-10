import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.logoPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 26,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 13, 106, 168).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(
                  255,
                  135,
                  128,
                  231,
                ).withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  logoPath,
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
      toolbarHeight: 90,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(90);
}
