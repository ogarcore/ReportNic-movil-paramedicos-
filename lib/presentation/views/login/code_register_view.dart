import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../views/register/register_view.dart';
import '../../widgets/custom_text_field.dart';
import '../../viewmodels/login/code_register_viewmodel.dart';

class CodigoRegistroView extends StatefulWidget {
  const CodigoRegistroView({super.key});

  @override
  _CodigoRegistroViewState createState() => _CodigoRegistroViewState();
}

class _CodigoRegistroViewState extends State<CodigoRegistroView> {
  final _codigoController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _codigoController.addListener(() {
      final text = _codigoController.text.toUpperCase();
      if (text.length > 6) {
        _codigoController.text = text.substring(0, 6);
        _codigoController.selection = TextSelection.collapsed(offset: 6);
      } else {
        _codigoController.value = _codigoController.value.copyWith(
          text: text,
          selection: TextSelection.collapsed(offset: text.length),
        );
      }

      setState(() {}); // Redibuja para que el botón se habilite/deshabilite
    });
  }

  @override
  void dispose() {
    _codigoController.dispose();
    super.dispose();
  }

  void _mostrarError(String mensaje) {
    setState(() {
      _errorMessage = mensaje;
    });
    
    // Opcional: Limpiar el mensaje después de 4 segundos
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        setState(() {
          _errorMessage = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);

    return ChangeNotifierProvider(
      create: (_) => CodigoRegistroViewModel(),
      child: Consumer<CodigoRegistroViewModel>(
        builder: (context, viewModel, _) => Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.only(top: 1, left: 10),
              child: IconButton(
                icon: Icon(
                  Icons.arrow_circle_left,
                  size: 40,
                  color: Colors.blue[800],
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  top: 8,
                  bottom: 8,
                  right: 16,
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    size: 30,
                    color: Colors.blue[800],
                  ),
                  onPressed: () => _showInfoDialog(context),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: width * 0.08),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 140),
                    Card(
                      color: const Color.fromARGB(255, 245, 245, 245),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Text(
                              'Registro de Paramédico',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[800],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ingrese el código proporcionado',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Campo de código
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextField(
                                  controller: _codigoController,
                                  label: 'Código de acceso',
                                  hintText: 'Ingrese el código...',
                                  icon: Icons.verified_user,
                                  keyboardType: TextInputType.visiblePassword,
                                  obscureText: false,
                                ),
                                if (_errorMessage != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,left: 8.0),
                                    child: Text(
                                      _errorMessage!,
                                      style: TextStyle(
                                        color: Colors.red[700],
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Botón verificar
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: viewModel.isVerifying ||
                                        _codigoController.text.length != 6
                                    ? null
                                    : () async {
                                        final codigo =
                                            _codigoController.text.trim();
                                        final estado = await viewModel
                                            .verificarCodigo(codigo);

                                        switch (estado) {
                                          case CodigoEstado.valido:
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => RegisterView(),
                                              ),
                                            );
                                            break;
                                          case CodigoEstado.yaUsado:
                                            _mostrarError(
                                                'El código ya fue utilizado.');
                                            break;
                                          case CodigoEstado.noExiste:
                                            _mostrarError('El código no existe.');
                                            break;
                                          case CodigoEstado.error:
                                            _mostrarError(
                                                'Ocurrió un error al verificar.');
                                            break;
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 3,
                                ),
                                child: viewModel.isVerifying
                                    ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      )
                                    : const Text(
                                        'VERIFICAR CÓDIGO',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Texto info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Para registrarse como paramédico, debe ingresar el código de acceso proporcionado por un administrador de ReportNic.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Logo
                    Center(
                      child: Image.asset(
                        'assets/images/logo_azul.png',
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showInfoDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Información',
        style: TextStyle(
          color: Colors.blue[800],
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Para registrarse como paramédico, necesita un código proporcionado por un administrador. Este código es único y se utiliza para que usted pueda registrarse en nuestra plataforma. Si usted no ha recibido un código antes de registrarse en ReportNic, por favor comuníquese con uno de los administradores de ReportNic.',
        style: TextStyle(color: Colors.grey[700], height: 1.4),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cerrar', style: TextStyle(color: Colors.blue[700])),
        ),
      ],
    ),
  );
}