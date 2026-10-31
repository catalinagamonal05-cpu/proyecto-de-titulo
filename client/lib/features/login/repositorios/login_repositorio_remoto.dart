import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/constantes/contante_server.dart';
import '../modelo/modelo_usuario.dart';
import '../../../core/falla/falla.dart';
part 'login_repositorio_remoto.g.dart';

@riverpod
LoginRepositorioRemoto loginRepositorioRemoto(Ref ref) {
  return LoginRepositorioRemoto();
}

class LoginRepositorioRemoto {
  static const _tokenKey = 'access_token';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Either<FallaApp, ModeloUsuario>> signup({
    required String nombre,
    required String email,
    required String password,
  }) async {
    try {
      final respuesta = await http.post(
        Uri.parse("${ConstanteServer.serverURL}/usuarios/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nombre': nombre,
          'email': email,
          'contrasena': password,
        }),
      );
      final resMap = jsonDecode(respuesta.body) as Map<String, dynamic>;
      if (respuesta.statusCode != 201) {
        return Left(
          FallaApp(
            resMap['detail']?.toString() ?? 'No se pudo crear la cuenta',
          ),
        );
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
        Uri.parse("${ConstanteServer.serverURL}/usuarios/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'contrasena': password}),
      );
      final resMap = jsonDecode(respuesta.body) as Map<String, dynamic>;
      if (respuesta.statusCode != 200) {
        return Left(
          FallaApp(resMap['detail']?.toString() ?? 'No se pudo iniciar sesión'),
        );
      }

      final token = resMap['access_token']?.toString();
      if (token == null || token.isEmpty) {
        return Left(FallaApp('La API no devolvió un token válido'));
      }

      final respuestaUsuario = await http.get(
        Uri.parse("${ConstanteServer.serverURL}/usuarios/me"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
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

      await _secureStorage.write(key: _tokenKey, value: token);
      return Right(ModeloUsuario.fromMap(usuarioMap).copyWith(token: token));
    } catch (e) {
      return Left(FallaApp(e.toString()));
    }
  }

  Future<String?> obtenerTokenGuardado() async {
    return _secureStorage.read(key: _tokenKey);
  }

  Future<Either<FallaApp, ModeloUsuario>> getCurrentUserData(
    String token,
  ) async {
    try {
      final respuesta = await http.get(
        Uri.parse("${ConstanteServer.serverURL}/usuarios/me"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final usuarioMap = jsonDecode(respuesta.body) as Map<String, dynamic>;
      if (respuesta.statusCode != 200) {
        await cerrarSesion();
        return Left(
          FallaApp(usuarioMap['detail']?.toString() ?? 'Sesión no válida'),
        );
      }
      return Right(ModeloUsuario.fromMap(usuarioMap).copyWith(token: token));
    } catch (e) {
      return Left(FallaApp(e.toString()));
    }
  }

  Future<Either<FallaApp, ModeloUsuario>> restaurarSesion() async {
    final token = await obtenerTokenGuardado();
    if (token == null || token.isEmpty) {
      return Left(FallaApp('No hay una sesión guardada'));
    }
    return getCurrentUserData(token);
  }

  Future<void> cerrarSesion() async {
    await _secureStorage.delete(key: _tokenKey);
  }
}
