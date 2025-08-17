import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/home/patient_view_model.dart';
import '../../widgets/section_header.dart';
import '../../widgets/modern_text_field.dart';
import 'map_view.dart';

class PatientView extends StatelessWidget {
  final String transcribedText;

  const PatientView({super.key, required this.transcribedText});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PatientViewModel(transcribedText),
      child: const _PatientViewBody(),
    );
  }
}

class _PatientViewBody extends StatelessWidget {
  const _PatientViewBody();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PatientViewModel>(context);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_rounded, color: Colors.blue[800]),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Ficha del Paciente',
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue[800]!, Colors.blue[600]!],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 5),
                          const Text(
                            'Registro en curso',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              _chip(
                                Icons.calendar_today_rounded,
                                vm.formattedDate,
                              ),
                              const SizedBox(width: 10),
                              _chip(
                                Icons.access_time_rounded,
                                vm.formattedTime,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 25),

              const SectionHeader(
                icon: Icons.person_outline_rounded,
                title: 'Datos Generales',
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ModernTextField(
                      controller: vm.nameController,
                      focusNode: vm.nameFocus,
                      label: 'Nombre Completo',
                      icon: Icons.person_rounded,
                      enabled: !vm.nameUnknown,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _toggleButton(
                      label: 'Desconocido',
                      active: vm.nameUnknown,
                      onTap: vm.toggleNameUnknown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: ModernTextField(
                      controller: vm.ageController,
                      focusNode: vm.ageFocus,
                      label: 'Edad',
                      icon: HugeIcons.strokeRoundedCalendar03,
                      keyboardType: TextInputType.number,
                      enabled: !vm.ageUnknown,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: _toggleButton(
                      label: 'Desconocida',
                      active: vm.ageUnknown,
                      onTap: vm.toggleAgeUnknown,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _dropdown(
                value: vm.gender,
                hint: 'Sexo',
                items: vm.genders,
                onChanged: (val) => vm.gender = val,
              ),
              const SizedBox(height: 25),

              const SectionHeader(
                icon: Icons.favorite_outline_rounded,
                title: 'Signos Vitales',
              ),

              const SizedBox(height: 15),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                bottom: 4.0,
                              ),
                              child: Text(
                                'Frec. Cardíaca',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: vm.heartRateController,
                                focusNode: vm.heartRateFocus,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '72',
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.monitor_heart_outlined,
                                    color: Color(0xFF1565C0),
                                  ),
                                  suffixText: 'lpm',
                                  suffixStyle: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8.0,
                                bottom: 4.0,
                              ),
                              child: Text(
                                'Temperatura',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: TextField(
                                controller: vm.temperatureController,
                                focusNode: vm.temperatureFocus,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '36.5',
                                  hintStyle: TextStyle(color: Colors.grey[500]),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 18,
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.thermostat_outlined,
                                    color: Color(0xFF1565C0),
                                  ),
                                  suffixText: '°C',
                                  suffixStyle: TextStyle(
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Presión Arterial",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Sistólica
                            Column(
                              children: [
                                Text(
                                  "Sistólica",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: 100,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller:
                                        vm.bloodPressureSystolicController,
                                    focusNode: vm.bloodPressureSystolicFocus,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "120",
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Text(
                                "/",
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 63, 100, 201),
                                ),
                              ),
                            ),
                            // Diastólica
                            Column(
                              children: [
                                Text(
                                  "Diastólica",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue[800],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  width: 100,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[50],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: TextField(
                                    controller:
                                        vm.bloodPressureDiastolicController,
                                    focusNode: vm.bloodPressureDiastolicFocus,
                                    textAlign: TextAlign.center,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.bold,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: "80",
                                      hintStyle: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                      border: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                "mmHg",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),

              const SectionHeader(
                icon: Icons.psychology_outlined,
                title: 'Nivel de Conciencia (AVPU)',
              ),
              const SizedBox(height: 15),
              _dropdown(
                value: vm.consciousnessLevel,
                hint: 'Seleccione nivel',
                items: vm.consciousnessLevels,
                onChanged: (val) => vm.consciousnessLevel = val,
              ),
              const SizedBox(height: 25),

              const SectionHeader(
                icon: Icons.medical_services_outlined,
                title: 'Afectaciones',
              ),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: vm.affectationsController,
                  focusNode: vm.affectationsFocus,
                  readOnly: true,
                  maxLines: 5,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                    suffixIcon: Icon(
                      Icons.edit_note_rounded,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blue[800]!, Colors.blue[600]!],
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapView(),
                        ),
                      );
                    },
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.map_rounded, color: Colors.white),
                          const SizedBox(width: 10),
                          Text(
                            'Ver en Mapa',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _toggleButton({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: active ? Colors.blue[800] : Colors.blue[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: active ? Colors.blue[800]! : Colors.blue[100]!,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: active ? Colors.white : Colors.blue[800],
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 3),
              Icon(
                active ? Icons.check : Icons.question_mark,
                size: 16,
                color: active ? Colors.white : Colors.blue[800],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint, style: TextStyle(color: Colors.grey[600])),
        icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.blue[800]),
        isExpanded: true,
        underline: const SizedBox(),
        items:
            items.map((String val) {
              return DropdownMenuItem<String>(
                value: val,
                child: Text(val, style: TextStyle(color: Colors.grey[800])),
              );
            }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
