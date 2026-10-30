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

      final token = resMap['access_token']?.toString();
      if (token == null || token.isEmpty) {
        return Left(FallaApp('La API no devolvió un token válido'));
      }

      final respuestaUsuario = await http.get(
        Uri.parse("http://127.0.0.1:8000/usuarios/me"),
        headers: {'Authorization': 'Bearer $token'},
      );
      final usuarioMap =
          jsonDecode(respuestaUsuario.body) as Map<String, dynamic>;
      if (respuestaUsuario.statusCode != 200) {
        return Left(
          FallaApp(
            usuarioMap['detail']?.toString() ?? 'No se pudo obtener el usuario',
          ),
        );
      }

      return Right(ModeloUsuario.fromMap(usuarioMap));
    } catch (e) {
      return Left(FallaApp(e.toString()));
    }
  }
}
