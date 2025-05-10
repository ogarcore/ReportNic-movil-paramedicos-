import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PatientView extends StatefulWidget {
  const PatientView({Key? key}) : super(key: key);

  @override
  _PatientViewState createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  // Controladores para los campos de texto
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _bloodPressureController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _respiratoryRateController = TextEditingController();
  final TextEditingController _affectationsController = TextEditingController();

  // Variables para los selectores
  String? _gender;
  String? _consciousnessLevel;
  bool _isEmergency = false;

  // Focus nodes para manejar el enfoque
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();
  final FocusNode _heartRateFocus = FocusNode();
  final FocusNode _bloodPressureFocus = FocusNode();
  final FocusNode _temperatureFocus = FocusNode();
  final FocusNode _respiratoryRateFocus = FocusNode();
  final FocusNode _affectationsFocus = FocusNode();

  // Opciones para los Dropdowns
  final List<String> _genders = ['Masculino', 'Femenino', 'Otro'];
  final List<String> _consciousnessLevels = ['Alerta', 'Verbal', 'Dolor', 'Inconsciente'];

  @override
  void dispose() {
    // Limpiar los focus nodes
    _nameFocus.dispose();
    _ageFocus.dispose();
    _heartRateFocus.dispose();
    _bloodPressureFocus.dispose();
    _temperatureFocus.dispose();
    _respiratoryRateFocus.dispose();
    _affectationsFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Quitar el foco de cualquier campo cuando se toque fuera
        FocusScope.of(context).unfocus();
      },
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
              // Tarjeta de información rápida
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
                      child: Icon(
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
                          Text(
                            'Paciente Nuevo',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Registro en curso',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Ahora',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _isEmergency = !_isEmergency;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _isEmergency
                                        ? Colors.red[400]
                                        : Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.warning_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        _isEmergency ? 'URGENCIA' : 'Normal',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
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
              ),
              const SizedBox(height: 25),

              // Sección de datos generales
              _buildSectionHeader(
                icon: Icons.person_outline_rounded,
                title: 'Datos Generales',
              ),
              const SizedBox(height: 15),
              _buildModernTextField(
                controller: _nameController,
                focusNode: _nameFocus,
                label: 'Nombre Completo',
                icon: Icons.person_rounded,
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildModernTextField(
                      controller: _ageController,
                      focusNode: _ageFocus,
                      label: 'Edad',
                      icon: HugeIcons.strokeRoundedCalendar03,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Container(
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
                        value: _gender,
                        hint: Text('Sexo', style: TextStyle(color: Colors.grey[600])),
                        icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.blue[800]),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: _genders.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value, style: TextStyle(color: Colors.grey[800])),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Sección de signos vitales
              _buildSectionHeader(
                icon: Icons.favorite_outline_rounded,
                title: 'Signos Vitales',
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                          child: Text(
                            'Frec. Cardíaca',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _buildModernTextField(
                          controller: _heartRateController,
                          focusNode: _heartRateFocus,
                          label: 'Ingrese valor',
                          icon: HugeIcons.strokeRoundedFavouriteSquare,
                          suffixText: 'lpm',
                          keyboardType: TextInputType.number,
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
                          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                          child: Text(
                            'Frec. Respiratoria',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _buildModernTextField(
                          controller: _respiratoryRateController,
                          focusNode: _respiratoryRateFocus,
                          label: 'Ingrese valor',
                          icon: Icons.air_rounded,
                          suffixText: 'rpm',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                          child: Text(
                            'Presión Arterial',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _buildModernTextField(
                          controller: _bloodPressureController,
                          focusNode: _bloodPressureFocus,
                          label: 'Ingrese valor',
                          icon: Icons.monitor_heart_outlined,
                          suffixText: 'mmHg',
                          keyboardType: TextInputType.number,
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
                          padding: const EdgeInsets.only(left: 8.0, bottom: 4),
                          child: Text(
                            'Temperatura',
                            style: TextStyle(
                              color: Colors.blue[800],
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _buildModernTextField(
                          controller: _temperatureController,
                          focusNode: _temperatureFocus,
                          label: 'Ingrese valor',
                          icon: Icons.thermostat_outlined,
                          suffixText: '°C',
                          keyboardType: TextInputType.number,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // Sección de nivel de conciencia
              _buildSectionHeader(
                icon: Icons.psychology_outlined,
                title: 'Nivel de Conciencia (AVPU)',
              ),
              const SizedBox(height: 15),
              Container(
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
                  value: _consciousnessLevel,
                  hint: Text('Seleccione nivel', style: TextStyle(color: Colors.grey[600])),
                  icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.blue[800]),
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: _consciousnessLevels.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.grey[800])),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _consciousnessLevel = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 25),

              // Sección de afectaciones
              _buildSectionHeader(
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
                  controller: _affectationsController,
                  focusNode: _affectationsFocus,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Describa las afectaciones del paciente...',
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                    suffixIcon: Icon(Icons.edit_note_rounded, color: Colors.grey[400]),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        side: BorderSide(color: Colors.blue[800]!),
                      ),
                      child: Text(
                        'CANCELAR',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[800],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'GUARDAR',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({required IconData icon, required String title}) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue[800], size: 20),
        ),
        const SizedBox(width: 15),
        Text(
          title,
          style: TextStyle(
            color: Colors.blue[800],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required IconData icon,
    String? suffixText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
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
        controller: controller,
        focusNode: focusNode,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          prefixIcon: Icon(icon, color: Colors.blue[800]),
          suffixText: suffixText,
          suffixStyle: TextStyle(
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}