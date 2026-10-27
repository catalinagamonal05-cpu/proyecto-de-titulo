import 'package:client/features/login/repositorios/login_repositorio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../widgets/botones.dart';
import '../widgets/txt_form.dart';
import 'login.dart';

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
    correoController.dispose();
    contrasenaController.dispose();
    super.dispose();
    formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Registrate',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
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
                  await LoginRepositorio().signup(
                    nombre: nombreController.text,
                    email: correoController.text,
                    password: contrasenaController.text,
                  );
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
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
