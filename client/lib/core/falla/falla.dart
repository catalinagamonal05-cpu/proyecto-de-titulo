class FallaApp {
  final String mensaje;
  FallaApp([this.mensaje = 'Ocurrió un error inesperado']);

  @override
  String toString() => 'FallaApp(mensaje: $mensaje)';
}
