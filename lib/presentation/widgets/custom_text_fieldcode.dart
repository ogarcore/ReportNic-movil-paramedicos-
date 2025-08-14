import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFieldCode extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool obscurePassword;
  final VoidCallback? togglePasswordVisibility;
  final TextInputType? keyboardType;
  final String label;
  final List<TextInputFormatter>? inputFormatters; // <-- agregado
  final bool obscureText; // <-- agregado

  const CustomTextFieldCode({super.key, 
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.label,
    this.isPassword = false,
    this.obscurePassword = false,
    this.togglePasswordVisibility,
    this.keyboardType,
    this.inputFormatters, // <-- agregado
    this.obscureText = false, required void Function(String value) onChanged, // <-- agregado
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? obscurePassword : obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      style: TextStyle(color: Colors.grey[800]),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        labelStyle: TextStyle(color: Colors.grey[700]),
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        hintStyle: TextStyle(color: Colors.grey[500]),
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: Colors.blue[700],
                  ),
                  onPressed: togglePasswordVisibility,
                )
                : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red[300]!),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red[400]!, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
