import 'package:client/features/login/modelo/modelo_usuario.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositorios/login_repositorio_remoto.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  late LoginRepositorioRemoto _loginRepositorioRemoto;

  @override
  AsyncValue<ModeloUsuario>? build() {
    _loginRepositorioRemoto = ref.watch(loginRepositorioRemotoProvider);
    return null;
  }

  Future<void> signup({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _loginRepositorioRemoto.signup(
      nombre: nombre,
      email: correo,
      password: password,
    );
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.mensaje, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }

  Future<void> restaurarSesion() async {
    state = const AsyncValue.loading();
    final res = await _loginRepositorioRemoto.restaurarSesion();
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.mensaje, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }

  Future<void> cerrarSesion() async {
    await _loginRepositorioRemoto.cerrarSesion();
    state = null;
  }

  Future<void> login({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    final res = await _loginRepositorioRemoto.login(
      email: correo,
      password: password,
    );
    switch (res) {
      case Left(value: final l):
        state = AsyncValue.error(l.mensaje, StackTrace.current);
      case Right(value: final r):
        state = AsyncValue.data(r);
    }
  }
}
