import 'package:flutter/foundation.dart';

/// 👤 Modelo de Usuario Completo
@immutable
class ModeloUsuario {
  const ModeloUsuario({
    required this.id,
    required this.email,
    this.nombre,
    this.avatarUrl,
    this.bio,
    this.telefono,
    this.creadoEn,
    this.actualizadoEn,
  });

  final String id;
  final String email;
  final String? nombre;
  final String? avatarUrl;
  final String? bio;
  final String? telefono;
  final DateTime? creadoEn;
  final DateTime? actualizadoEn;

  factory ModeloUsuario.fromMap(Map<String, dynamic> map) {
    return ModeloUsuario(
      id: map['id'] as String,
      email: map['email'] as String,
      nombre: map['name'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      bio: map['bio'] as String?,
      telefono: map['phone'] as String?,
      creadoEn: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
      actualizadoEn: map['updated_at'] != null
          ? DateTime.parse(map['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': nombre,
      'avatar_url': avatarUrl,
      'bio': bio,
      'phone': telefono,
      'created_at': creadoEn?.toIso8601String(),
      'updated_at': actualizadoEn?.toIso8601String(),
    };
  }

  ModeloUsuario copyWith({
    String? id,
    String? email,
    String? nombre,
    String? avatarUrl,
    String? bio,
    String? telefono,
    DateTime? creadoEn,
    DateTime? actualizadoEn,
  }) {
    return ModeloUsuario(
      id: id ?? this.id,
      email: email ?? this.email,
      nombre: nombre ?? this.nombre,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      telefono: telefono ?? this.telefono,
      creadoEn: creadoEn ?? this.creadoEn,
      actualizadoEn: actualizadoEn ?? this.actualizadoEn,
    );
  }
}
