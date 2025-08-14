import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String logoPath;
  final bool automaticallyImplyLeading;

  const CustomHeader({
    super.key,
    required this.title,
    this.automaticallyImplyLeading = false, required this.logoPath,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(1),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  logoPath,
                  width: 100,
                  height: 60,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
              fontSize: 26,
              letterSpacing: 1.5,
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
            colors: [Color.fromARGB(255, 24, 74, 148), Color.fromARGB(255, 36, 124, 212)],
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
            bottom: Radius.circular(40),
          ),
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarHeight: 100,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(125);
}
