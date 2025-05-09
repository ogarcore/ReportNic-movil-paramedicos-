import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class UnitTypeAhead extends StatefulWidget {
  final List<String> opciones;
  final String? selectedValue;
  final Function(String) onSuggestionSelected;
  final bool showError;
  final TextEditingController controller;
  final FocusNode? focusNode; // Recibe el FocusNode
  final VoidCallback? onFieldTapped;

  const UnitTypeAhead({
    required this.opciones,
    required this.selectedValue,
    required this.onSuggestionSelected,
    required this.controller,
    this.showError = false,
    this.focusNode, // Acepta el FocusNode
    this.onFieldTapped,
    super.key,
  });

  @override
  State<UnitTypeAhead> createState() => _UnitTypeAheadState();
}

class _UnitTypeAheadState extends State<UnitTypeAhead> {


  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return TypeAheadFormField<String>(
      textFieldConfiguration: TextFieldConfiguration(
        controller: widget.controller,
        focusNode: widget.focusNode, 
        style: TextStyle(color: Colors.grey[800]),
        decoration: InputDecoration(
          hintText: 'Escribe el código de unidad',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(
            Icons.medical_services_outlined,
            color: Colors.blue[700],
          ),
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
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
      suggestionsCallback:
          (pattern) =>
              widget.opciones
                  .where(
                    (item) =>
                        item.toLowerCase().contains(pattern.toLowerCase()),
                  )
                  .toList(),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        elevation: 6.0,
        shadowColor: Colors.black26,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.4,
        ),
      ),
      itemBuilder:
          (context, suggestion) => Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1.0),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.emergency_outlined,
                  color: Colors.blue[700],
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    suggestion,
                    style: TextStyle(color: Colors.grey[800], fontSize: 16),
                  ),
                ),
                if (widget.selectedValue == suggestion)
                  Icon(Icons.check, color: Colors.green[600], size: 20),
              ],
            ),
          ),
      onSuggestionSelected: (suggestion) {
        widget.onSuggestionSelected(suggestion);
        // Opcional: Quitar foco DESPUÉS de seleccionar para cerrar teclado/sugerencias
        // widget.focusNode?.unfocus();
      },
      noItemsFoundBuilder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'No se encontraron unidades',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ),
      loadingBuilder:
          (context) => Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              ),
            ),
          ),
      transitionBuilder:
          (context, suggestionsBox, controller) => FadeTransition(
            opacity: controller!.drive(CurveTween(curve: Curves.fastOutSlowIn)),
            child: suggestionsBox,
          ),
    );
  }
}
