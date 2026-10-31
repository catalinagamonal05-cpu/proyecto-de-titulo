import 'package:client/features/login/vista/paginas/acceso.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../core/utility.dart';
import '../../../../core/widgets/carga.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../../../homepage/vista/paginas/homepage.dart';
import '../widgets/botones.dart';
import '../widgets/txt_form.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cargando = ref.watch(authViewmodelProvider)?.isLoading == true;

    ref.listen(authViewmodelProvider, (_, next) {
      next?.when(
        data: (data) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        },
        error: (error, st) {
          showSnackBar(context, error.toString());
        },
        loading: () {},
      );
    });

    return Scaffold(
      appBar: AppBar(),
      body: cargando
          ? const Carga()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Iniciar sesión',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    TxtForm(
                      hintText: 'Correo electrónico',
                      controller: correoController,
                    ),

                    const SizedBox(height: 15),
                    TxtForm(
                      hintText: 'Contraseña',
                      controller: contrasenaController,
                      isObscureText: true,
                    ),

                    const SizedBox(height: 20),
                    Boton(
                      text: 'Continuar',
                      apretar: () async {
                        if (formKey.currentState!.validate()) {
                          await ref
                              .read(authViewmodelProvider.notifier)
                              .login(
                                correo: correoController.text.trim(),
                                password: contrasenaController.text.trim(),
                                nombre: '',
                              );
                        }
                      },
                    ),

                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // Navegar a la página de registro
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Acceso(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '¿No tienes cuenta? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            TextSpan(
                              text: 'Registrate',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
