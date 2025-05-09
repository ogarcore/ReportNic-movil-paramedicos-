import 'package:flutter/material.dart';
import '../../viewmodels/login/unit_dropdown_viewmodel.dart';
import '../../views/login/login_view.dart';

class EmailVerifiedScreen extends StatelessWidget {
  const EmailVerifiedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => LoginView(unitVM: UnitDropdownViewModel())),
          (Route<dynamic> route) => false,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  // Ilustración animada
                  _buildVerifiedIllustration(),
                  const SizedBox(height: 40),
                  // Título y mensaje
                  _buildVerifiedHeader(),
                  const SizedBox(height: 40),
                  // Botón de inicio de sesión
                  _buildLoginButton(context),
                  const SizedBox(height: 40),
                  // Elementos adicionales
                  _buildAdditionalElements(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifiedIllustration() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[50],
        boxShadow: [
          BoxShadow(
            color: Colors.blue[100]!.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.all(30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.email, size: 100, color: Colors.blue[800]),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.verified, size: 30, color: Colors.green[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifiedHeader() {
    return Column(
      children: [
        Text(
          '¡Email Verificado!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.blue[900],
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Tu dirección de correo electrónico ha sido verificada con éxito. '
          'Ahora puedes acceder a todas las funciones de la aplicación.',
          style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Navegar al login (por implementar)
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginView(unitVM: UnitDropdownViewModel())),
            (Route<dynamic> route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          shadowColor: Colors.blue[300],
        ),
        child: const Text(
          'INICIAR SESIÓN',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalElements() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Image.asset(
          'assets/images/logo_azul.png',
          width: 100,
          height: 60,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
