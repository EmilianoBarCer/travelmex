import 'package:flutter/foundation.dart';

/// ⭐ Modelo de Reseña
@immutable
class ModeloResena {
  const ModeloResena({
    required this.id,
    required this.destinoId,
    required this.usuarioId,
    required this.comentario,
    required this.calificacion,
    this.nombreUsuario,
    this.avatarUsuario,
    this.creadoEn,
  });

  final String id;
  final String destinoId;
  final String usuarioId;
  final String comentario;
  final int calificacion; // 1-5
  final String? nombreUsuario;
  final String? avatarUsuario;
  final DateTime? creadoEn;

  factory ModeloResena.fromMap(Map<String, dynamic> map) {
    return ModeloResena(
      id: map['id'] as String,
      destinoId: map['destination_id'] as String,
      usuarioId: map['user_id'] as String,
      comentario: map['comment'] as String,
      calificacion: map['rating'] as int,
      nombreUsuario: map['nombre_usuario'] as String?,
      avatarUsuario: map['avatar_usuario'] as String?,
      creadoEn: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'destination_id': destinoId,
      'user_id': usuarioId,
      'comment': comentario,
      'rating': calificacion,
      'created_at': creadoEn?.toIso8601String(),
    };
  }

  /// Verifica si la reseña es reciente (menos de 1 día)
  bool get esReciente {
    if (creadoEn == null) return false;
    return DateTime.now().difference(creadoEn!).inHours < 24;
  }

  /// Obtiene texto legible de hace cuánto tiempo
  String get tiempoTranscurrido {
    if (creadoEn == null) return 'Hace poco';
    final diferencia = DateTime.now().difference(creadoEn!);
    
    if (diferencia.inMinutes < 60) {
      return 'Hace ${diferencia.inMinutes} min';
    } else if (diferencia.inHours < 24) {
      return 'Hace ${diferencia.inHours} horas';
    } else if (diferencia.inDays < 7) {
      return 'Hace ${diferencia.inDays} días';
    } else {
      return 'Hace ${(diferencia.inDays / 7).floor()} semanas';
    }
  }
}
