import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../viewmodels/register/register_viewmodel.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_header.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _viewModel = RegisterViewModel();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('¿Deseas salir del registro?'),
              content: Text('Se perderán todos los datos que hayas ingresado.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Aceptar'),
                ),
              ],
            );
          },
        );
        return shouldPop ?? false;
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: width * 0.08),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomHeader(),
                const SizedBox(height: 30),
                Text(
                  'Registro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.blue[800],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 30),
                _buildField(
                  label: 'Nombre',
                  controller: _viewModel.nombreController,
                  icon: Icons.person,
                  hint: 'Ingrese su nombre',
                  errorListenable: _viewModel.nombreError,
                ),
                _buildField(
                  label: 'Apellido',
                  controller: _viewModel.apellidoController,
                  icon: Icons.person_outline,
                  hint: 'Ingrese su apellido',
                  errorListenable: _viewModel.apellidoError,
                ),
                _buildField(
                  label: 'Cédula de Identidad',
                  controller: _viewModel.cedulaController,
                  icon: Icons.badge,
                  hint: 'Ingrese su número de cédula',
                  errorListenable: _viewModel.cedulaError,
                  inputType: TextInputType.visiblePassword,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(17),
                    CedulaInputFormatter(),
                  ],
                ),
                _buildField(
                  label: 'Correo electrónico',
                  controller: _viewModel.emailController,
                  icon: Icons.email,
                  hint: 'Ingrese su correo',
                  errorListenable: _viewModel.emailError,
                  inputType: TextInputType.emailAddress,
                ),
                _buildField(
                  label: 'Contraseña',
                  controller: _viewModel.passwordController,
                  icon: Icons.lock,
                  hint: 'Ingrese su contraseña',
                  errorListenable: _viewModel.passwordError,
                  isPassword: true,
                  obscureText: _obscurePassword,
                  toggleVisibility: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
                const SizedBox(height: 20),
                ValueListenableBuilder<String?>(
                  valueListenable: _viewModel.errorMessage,
                  builder: (_, message, __) {
                    if (message == null) return const SizedBox.shrink();
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        message,
                        style: TextStyle(color: Colors.red[700], fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _viewModel.isLoading,
                  builder: (_, isLoading, __) {
                    return ElevatedButton(
                      onPressed:
                          isLoading ? null : () => _viewModel.register(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child:
                          isLoading
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text(
                                'REGISTRARSE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                  color: Colors.white,
                                ),
                              ),
                    );
                  },
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required ValueNotifier<String?> errorListenable,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? toggleVisibility,
  }) {
    return ValueListenableBuilder<String?>(
      valueListenable: errorListenable,
      builder: (_, error, __) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: controller,
                label: label,
                icon: icon,
                hintText: hint,
                keyboardType: inputType,
                inputFormatters: inputFormatters,
                isPassword: isPassword,
                obscurePassword: obscureText,
                togglePasswordVisibility: toggleVisibility,
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 8),
                  child: Text(
                    error,
                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class CedulaInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String input = newValue.text.replaceAll(RegExp(r'[^0-9a-zA-Z]'), '');

    if (input.length > 14) {
      input = input.substring(0, 14);
    }

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      if (i < 13) {
        if (RegExp(r'[0-9]').hasMatch(input[i])) {
          buffer.write(input[i]);
        }
      } else if (i == 13) {
        if (RegExp(r'[a-zA-Z]').hasMatch(input[i])) {
          buffer.write(input[i].toUpperCase());
        }
      }
    }

    String finalText = buffer.toString();
    if (finalText.length > 3) {
      finalText = '${finalText.substring(0, 3)}-${finalText.substring(3)}';
    }
    if (finalText.length > 10) {
      finalText = '${finalText.substring(0, 10)}-${finalText.substring(10)}';
    }

    int offset = finalText.length;
    if (oldValue.text.length > newValue.text.length) {
      offset = newValue.selection.base.offset;
    }

    return TextEditingValue(
      text: finalText,
      selection: TextSelection.collapsed(offset: offset),
    );
  }
}
