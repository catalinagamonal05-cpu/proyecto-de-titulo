import 'dart:convert';

class ModeloUsuario {
  final String nombre;
  final String correo;
  final String id;
  final String token;

  const ModeloUsuario({
    required this.nombre,
    required this.correo,
    required this.id,
    this.token = '',
  });

  ModeloUsuario copyWith({
    String? nombre,
    String? correo,
    String? id,
    String? token,
  }) {
    return ModeloUsuario(
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      id: id ?? this.id,
      token: token ?? this.token,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'nombre': nombre,
      'correo': correo,
      'id': id,
      'token': token,
    };
  }

  factory ModeloUsuario.fromMap(Map<String, dynamic> map) {
    final datosUsuario = map['usuario'] is Map<String, dynamic>
        ? map['usuario'] as Map<String, dynamic>
        : map;

    final nombre = datosUsuario['nombre']?.toString() ?? '';
    final correo =
        (datosUsuario['correo'] ?? datosUsuario['email'])?.toString() ?? '';
    final id =
        (datosUsuario['id'] ?? datosUsuario['id_usuario'])?.toString() ?? '';

    return ModeloUsuario(
      nombre: nombre,
      correo: correo,
      id: id,
      token: datosUsuario['token']?.toString() ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloUsuario.fromJson(String source) =>
      ModeloUsuario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ModeloUsuario(nombre: $nombre, correo: $correo, id: $id, token: ${token.isEmpty ? 'vacío' : 'presente'})';

  @override
  bool operator ==(covariant ModeloUsuario other) {
    if (identical(this, other)) return true;

    return other.nombre == nombre && other.correo == correo && other.id == id;
  }

  @override
  int get hashCode => nombre.hashCode ^ correo.hashCode ^ id.hashCode;
}
