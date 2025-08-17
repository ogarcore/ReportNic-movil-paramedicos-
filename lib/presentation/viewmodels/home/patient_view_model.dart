import 'package:flutter/material.dart';

class PatientViewModel extends ChangeNotifier {
  // Controladores
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heartRateController = TextEditingController();
  final TextEditingController bloodPressureSystolicController =
      TextEditingController();
  final TextEditingController bloodPressureDiastolicController =
      TextEditingController();
  final TextEditingController temperatureController = TextEditingController();
  final TextEditingController affectationsController = TextEditingController();

  // FocusNodes
  final FocusNode nameFocus = FocusNode();
  final FocusNode ageFocus = FocusNode();
  final FocusNode heartRateFocus = FocusNode();
  final FocusNode bloodPressureSystolicFocus = FocusNode();
  final FocusNode bloodPressureDiastolicFocus = FocusNode();
  final FocusNode temperatureFocus = FocusNode();
  final FocusNode affectationsFocus = FocusNode();

  // Estado
  bool nameUnknown = false;
  bool ageUnknown = false;
  String? _gender;
  String? get gender => _gender;
  set gender(String? value) {
    _gender = value;
    notifyListeners();
  }

  String? _consciousnessLevel;
  String? get consciousnessLevel => _consciousnessLevel;
  set consciousnessLevel(String? value) {
    _consciousnessLevel = value;
    notifyListeners();
  }

  // Listas para dropdowns
  final List<String> genders = ['Masculino', 'Femenino', 'Otro'];
  final List<String> consciousnessLevels = [
    'Alerta',
    'Verbal',
    'Dolor',
    'Inconsciente',
  ];

  late final DateTime creationDate;
  late final String formattedDate;
  late final String formattedTime;

  PatientViewModel(String transcribedText) {
    affectationsController.text = transcribedText;
    creationDate = DateTime.now();
    formattedDate =
        '${creationDate.day}/${creationDate.month}/${creationDate.year}';
    formattedTime =
        '${creationDate.hour}:${creationDate.minute.toString().padLeft(2, '0')}';
  }

  void toggleNameUnknown() {
    nameUnknown = !nameUnknown;
    if (nameUnknown) {
      nameController.text = 'DESCONOCIDO';
    } else {
      nameController.clear();
    }
    notifyListeners();
  }

  void toggleAgeUnknown() {
    ageUnknown = !ageUnknown;
    if (ageUnknown) {
      ageController.text = 'DESCONOCIDA';
    } else {
      ageController.clear();
    }
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    heartRateController.dispose();
    bloodPressureSystolicController.dispose();
    bloodPressureDiastolicController.dispose();
    temperatureController.dispose();
    affectationsController.dispose();
    nameFocus.dispose();
    ageFocus.dispose();
    heartRateFocus.dispose();
    bloodPressureSystolicFocus.dispose();
    bloodPressureDiastolicFocus.dispose();
    temperatureFocus.dispose();
    affectationsFocus.dispose();
    super.dispose();
  }
}
