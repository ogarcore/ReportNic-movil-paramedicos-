import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../viewmodels/login/unit_dropdown_viewmodel.dart';
import '../../viewmodels/register/verification_viewmodel.dart';
import '../register/verificated_view.dart';
import '../../views/login/login_view.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final VerificationViewModel _viewModel;
  @override
  void initState() {
    super.initState();
    _viewModel = VerificationViewModel();
    _viewModel.sendVerificationEmail();
    _startEmailCheckLoop();
  }

  Future<void> _sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  void _startEmailCheckLoop() {
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      final isVerified = await _viewModel.checkIfEmailVerifiedAndUpdate();

      if (isVerified && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const EmailVerifiedScreen()),
        );
        return false;
      }
      return true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('¿Estás seguro?'),
                content: const Text(
                  'Si regresas ahora, deberás completar el proceso de verificación más tarde.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Aceptar'),
                  ),
                ],
              ),
        );

        if (shouldPop ?? false) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => LoginView(unitVM: UnitDropdownViewModel())),
            (route) => false,
          );
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 120),
                _buildVerificationHeader(),
                const SizedBox(height: 40),
                _buildIllustration(),
                const SizedBox(height: 30),
                const SizedBox(height: 20),
                _buildAdditionalInfo(),
                _buildLogoPlaceholder(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoPlaceholder() {
    return Image.asset('assets/images/logo_azul.png', width: 80, height: 60);
  }

  Widget _buildVerificationHeader() {
    return Column(
      children: [
        Text(
          'Verifica tu dirección de correo electrónico',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          'Hemos enviado un enlace de verificación a tu correo. Por favor ábrelo para completar el proceso.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIllustration() {
    return Icon(
      Icons.mark_email_read_outlined,
      size: 100,
      color: Colors.blue[500],
    );
  }

  Widget _buildAdditionalInfo() {
    return Column(
      children: [
        Text(
          'Si no encuentras el correo, revisa tu carpeta de spam.',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: _sendVerificationEmail,
          child: Text(
            'Reenviar correo de verificación',
            style: TextStyle(color: Colors.blue[500], fontSize: 14),
          ),
        ),
      ],
    );
  }
}
