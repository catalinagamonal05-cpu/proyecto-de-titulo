import 'package:client/features/login/vista/paginas/login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../../core/utility.dart';
import '../../../../core/widgets/carga.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../widgets/botones.dart';
import '../widgets/txt_form.dart';

class Acceso extends ConsumerStatefulWidget {
  const Acceso({super.key});

  @override
  ConsumerState<Acceso> createState() => _AccesoState();
}

class _AccesoState extends ConsumerState<Acceso> {
  final nombreController = TextEditingController();
  final correoController = TextEditingController();
  final contrasenaController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    nombreController.dispose();
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
          showSnackBar(context, 'Cuenta creada correctamente');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Acceso()),
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
                      'Registrate',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),
                    TxtForm(hintText: 'Nombre', controller: nombreController),

                    const SizedBox(height: 15),
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
                              .signup(
                                nombre: nombreController.text.trim(),
                                correo: correoController.text.trim(),
                                password: contrasenaController.text.trim(),
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
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '¿Ya tienes cuenta? ',
                          style: Theme.of(context).textTheme.titleMedium,
                          children: [
                            const TextSpan(
                              text: 'Iniciar sesión',
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
