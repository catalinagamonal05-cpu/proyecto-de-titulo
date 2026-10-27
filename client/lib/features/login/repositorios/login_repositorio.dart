import 'dart:convert';

import 'package:http/http.dart' as http;

class LoginRepositorio {
  Future<void> signup({
    required String nombre,
    required String email,
    required String password,
  }) async {
    final respuesta = await http.post(
      Uri.parse("http://127.0.0.1:8000/usuarios/"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'email': email,
        'contrasena': password,
      }),
    );
    print(respuesta.body);
    print(respuesta.statusCode);
    // Implementa la lógica de registro aquí
  }

  Future<void> login({required String email, required String password}) async {
    final respuesta = await http.post(
      Uri.parse("http://127.0.0.1:8000/usuarios/login"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'contrasena': password}),
    );
    print(respuesta.body);
    print(respuesta.statusCode);
    // Implementa la lógica de inicio de sesión aquí
  }
}
