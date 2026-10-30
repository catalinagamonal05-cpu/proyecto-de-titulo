import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

import '../../repositorios/login_repositorio.dart';
import '../widgets/botones.dart';
import '../widgets/txt_form.dart';
import 'acceso.dart';

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
                'Iniciar sesión',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
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
                  final res = await LoginRepositorio().login(
                    email: correoController.text,
                    password: contrasenaController.text,
                  );
                  final val = switch (res) {
                    Left(value: final l) => l,
                    Right(value: final r) => r,
                  };
                  print(val);
                },
              ),

              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navegar a la página de registro
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Acceso()),
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
