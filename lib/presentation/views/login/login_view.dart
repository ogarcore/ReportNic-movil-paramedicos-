import 'package:flutter/material.dart';
import '../../viewmodels/login/login_viewmodel.dart';
import '../../viewmodels/login/unit_dropdown_viewmodel.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/labeled_field.dart';
import '../../widgets/custom_header.dart';
import '../../widgets/unit_typeahead.dart'; // Asegúrate que la ruta sea correcta

class LoginView extends StatefulWidget {
  final UnitDropdownViewModel unitVM;
  const LoginView({super.key, required this.unitVM});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _viewModel = LoginViewModel();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String? _selectedUnit;
  bool _submitted = false;
  late UnitDropdownViewModel _unitDropdownViewModel;
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _unitFocusNode = FocusNode();
  final GlobalKey _unitKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  // NUEVA VARIABLE DE ESTADO PARA CONTROLAR EL SCROLL
  bool _isScrollDisabledByFocus = false;

  @override
  void initState() {
    super.initState();
    _unitDropdownViewModel = widget.unitVM;
    _unitFocusNode.addListener(_onUnitFocusChange);
    _emailFocusNode.addListener(_onEmailFocusChange);
    _passwordFocusNode.addListener(_onPasswordFocusChange);
  }

  void _onEmailFocusChange() {
    if (_emailFocusNode.hasFocus) {
      setState(() {
        _isScrollDisabledByFocus = true;
      });
      // Código original del usuario mantenido
      _scrollController.jumpTo(
        0,
      ); // Cancela el scroll cuando el email está en focus
    } else {
      // Solo habilitar scroll si el campo de contraseña tampoco tiene foco
      if (!_passwordFocusNode.hasFocus) {
        setState(() {
          _isScrollDisabledByFocus = false;
        });
      }
    }
  }

  void _onPasswordFocusChange() {
    if (_passwordFocusNode.hasFocus) {
      setState(() {
        _isScrollDisabledByFocus = true;
      });
      // Código original del usuario mantenido
      _scrollController.jumpTo(
        0,
      ); // Cancela el scroll cuando la contraseña está en focus
    } else {
      // Solo habilitar scroll si el campo de correo tampoco tiene foco
      if (!_emailFocusNode.hasFocus) {
        setState(() {
          _isScrollDisabledByFocus = false;
        });
      }
    }
  }

  void _onUnitFocusChange() {
    if (_unitFocusNode.hasFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted &&
              _unitFocusNode.hasFocus &&
              _unitKey.currentContext != null) {
            if (!_scrollController.hasClients ||
                !_scrollController.position.hasContentDimensions) {
              return;
            }
            try {
              final targetContext = _unitKey.currentContext!;
              final renderBox = targetContext.findRenderObject() as RenderBox?;
              if (renderBox != null && renderBox.attached) {
                _scrollController.position.context.storageContext
                    .findRenderObject(); // Cast as RenderBox? is implicit
                Scrollable.ensureVisible(
                  targetContext,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: 0.5,
                );
              }
            } catch (e, stackTrace) {
              print("Unidad Focus: Error en ensureVisible: $e");
              print("Unidad Focus: StackTrace: $stackTrace");
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    _viewModel.unidadController.dispose();
    _emailFocusNode.removeListener(
      _onEmailFocusChange,
    ); // Remover listener antes de dispose
    _emailFocusNode.dispose();
    _passwordFocusNode.removeListener(
      _onPasswordFocusChange,
    ); // Remover listener antes de dispose
    _passwordFocusNode.dispose();
    _unitFocusNode.removeListener(_onUnitFocusChange);
    _unitFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.06),
            child: Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    autovalidateMode:
                        _submitted
                            ? AutovalidateMode.always
                            : AutovalidateMode.disabled,
                    child: ListView(
                      controller: _scrollController,
                      key: const PageStorageKey('login_list_view'),
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 30,
                      ),
                      physics:
                          _isScrollDisabledByFocus
                              ? const NeverScrollableScrollPhysics()
                              : const BouncingScrollPhysics(),
                      children: [
                        CustomHeader(),
                        const SizedBox(height: 50),
                        Text(
                          'Inicio de Sesión',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Colors.blue[800],
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // --- Correo Electrónico ---
                        ValueListenableBuilder<String?>(
                          valueListenable: _viewModel.emailError,
                          builder: (_, error, __) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  label: 'Correo Electrónico',
                                  controller: _viewModel.emailController,
                                  focusNode: _emailFocusNode,
                                  hintText: 'Ingrese su correo',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                if (error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      left: 8,
                                    ),
                                    child: Text(
                                      error,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 25),

                        // --- Contraseña ---
                        ValueListenableBuilder<String?>(
                          valueListenable: _viewModel.passwordError,
                          builder: (_, error, __) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  label: 'Contraseña',
                                  controller: _viewModel.passwordController,
                                  focusNode: _passwordFocusNode,
                                  hintText: 'Ingrese su contraseña',
                                  icon: Icons.lock_outline,
                                  isPassword: true,
                                  obscurePassword: _obscurePassword,
                                  togglePasswordVisibility: () {
                                    setState(
                                      () =>
                                          _obscurePassword = !_obscurePassword,
                                    );
                                  },
                                ),
                                if (error != null)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 4,
                                      left: 8,
                                    ),
                                    child: Text(
                                      error,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 25),

                        // --- Unidad de Ambulancia (TypeAhead) ---
                        ValueListenableBuilder<List<String>>(
                          valueListenable: _unitDropdownViewModel.unidades,
                          builder: (context, unidades, _) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: _unitDropdownViewModel.isLoading,
                              builder: (context, isLoading, _) {
                                if (isLoading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return LabeledField(
                                  label: 'Unidad de Ambulancia',
                                  validator:
                                      (_) =>
                                          _selectedUnit == null
                                              ? 'Seleccione una Unidad'
                                              : null,
                                  value: _selectedUnit,
                                  submitted: _submitted,
                                  child: KeyedSubtree(
                                    key: _unitKey,
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: UnitTypeAhead(
                                        opciones: unidades,
                                        selectedValue: _selectedUnit,
                                        onSuggestionSelected: (value) {
                                          setState(() => _selectedUnit = value);
                                          _viewModel.unidadController.text =
                                              value;
                                          // Forzar validación de LabeledField después de seleccionar unidad si ya se intentó enviar
                                          if (_submitted) {
                                            _formKey.currentState?.validate();
                                          }
                                        },
                                        controller: _viewModel.unidadController,
                                        showError:
                                            _submitted && _selectedUnit == null,
                                        focusNode: _unitFocusNode,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 40),

                        // --- Botón de Login ---
                        _buildLoginButton(), // MÉTODO MODIFICADO
                        ValueListenableBuilder<String?>(
                          valueListenable: _viewModel.verificationError,
                          builder: (_, error, __) {
                            if (error == null) return const SizedBox.shrink();
                            return Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                error,
                                style: const TextStyle(color: Colors.red),
                                textAlign: TextAlign.center,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildRegisterLink(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(16),
      shadowColor: const Color(0xFF4285F4).withAlpha(128),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue[800],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shadowColor: Colors.transparent,
        ),
        onPressed:
            _isLoading
                ? null
                : () async {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    // Marcar como "submitted" para activar AutovalidateMode.always
                    // y la lógica de showError en UnitTypeAhead
                    _submitted = true;
                  });

                  // 1. Validar campos de texto (correo, contraseña) a través del ViewModel
                  // Esto actualizará viewModel.emailError y viewModel.passwordError
                  final bool textFieldsValid = _viewModel.validateFields();

                  // 2. Validar el Form (esto incluye el LabeledField de la unidad de ambulancia)
                  final bool formIsValid = _formKey.currentState!.validate();

                  // 3. Comprobar explícitamente si la unidad fue seleccionada
                  final bool unitIsSelected = _selectedUnit != null;

                  // Si todas las validaciones pasan, proceder con el login
                  if (textFieldsValid && formIsValid && unitIsSelected) {
                    setState(() => _isLoading = true);
                    await _viewModel.login(context, _selectedUnit);
                    if (mounted) {
                      setState(() => _isLoading = false);
                    }
                  } else {
                  }
                },
        child: SizedBox(
          height: 20,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: _isLoading ? 0 : 1,
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_isLoading)
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade700],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: TextButton(
        style: TextButton.styleFrom(foregroundColor: Colors.blue[700]),
        onPressed: () {
          _viewModel.navigateToRegister(context);
        },
        child: Text(
          '¿No tienes una cuenta? Regístrate aquí',
          style: TextStyle(color: Colors.blue[700]),
        ),
      ),
    );
  }
}
