import 'dart:convert';

class ModeloUsuario {
  final String nombre;
  final String correo;
  final String id;

  const ModeloUsuario({
    required this.nombre,
    required this.correo,
    required this.id,
  });

  ModeloUsuario copyWith({String? nombre, String? correo, String? id}) {
    return ModeloUsuario(
      nombre: nombre ?? this.nombre,
      correo: correo ?? this.correo,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'nombre': nombre, 'correo': correo, 'id': id};
  }

  factory ModeloUsuario.fromMap(Map<String, dynamic> map) {
    return ModeloUsuario(
      nombre: map['nombre'] ?? '',
      correo: map['correo'] ?? '',
      id: map['id'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ModeloUsuario.fromJson(String source) =>
      ModeloUsuario.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ModeloUsuario(nombre: $nombre, correo: $correo, id: $id)';

  @override
  bool operator ==(covariant ModeloUsuario other) {
    if (identical(this, other)) return true;

    return other.nombre == nombre && other.correo == correo && other.id == id;
  }

  @override
  int get hashCode => nombre.hashCode ^ correo.hashCode ^ id.hashCode;
}
