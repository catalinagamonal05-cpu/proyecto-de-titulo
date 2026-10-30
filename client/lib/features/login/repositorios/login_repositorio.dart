import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;

import '../modelo/modelo_usuario.dart';
import '../../../core/falla/falla.dart';

class LoginRepositorio {
  Future<Either<FallaApp, ModeloUsuario>> signup({
    required String nombre,
    required String email,
    required String password,
  }) async {
    try {
      final respuesta = await http.post(
        Uri.parse("http://127.0.0.1:8000/usuarios/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'email': email,
          'contrasena': password,
        }),
      );
      final resMap = jsonDecode(respuesta.body) as Map<String, dynamic>;
      if (respuesta.statusCode != 201) {
        //{'detail': 'El correo electrónico ya está registrado.'}
        return Left(FallaApp(resMap['detail']));
      }
      return Right(ModeloUsuario.fromMap(resMap));
      // Implementa la lógica de registro aquí
    } catch (e) {
      return Left(FallaApp(e.toString()));
    }
  }

  Future<Either<FallaApp, ModeloUsuario>> login({
    required String email,
    required String password,
  }) async {
    try {
      final respuesta = await http.post(
        Uri.parse("http://127.0.0.1:8000/usuarios/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'contrasena': password}),
      );
      final resMap = jsonDecode(respuesta.body) as Map<String, dynamic>;
      if (respuesta.statusCode != 200) {
        return Left(FallaApp(resMap['detail']));
      }
      return Right(ModeloUsuario.fromMap(resMap));
      // Implementa la lógica de inicio de sesión aquí
    } catch (e) {
      return Left(FallaApp(e.toString()));
    }
  }
}
