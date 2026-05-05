import 'dart:math';
import 'package:flutter/foundation.dart';

/// 📍 Modelo de Destino Turístico
@immutable
class ModeloDestino {
  const ModeloDestino({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.ubicacion,
    required this.latitud,
    required this.longitud,
    this.precioPorNoche = 0.0,
    this.calificacionPromedio = 0.0,
    this.urlImagen,
    this.categoriaId,
    this.esDestacado = false,
    this.creadoEn,
  });

  final String id;
  final String nombre;
  final String descripcion;
  final String ubicacion;
  final double latitud;
  final double longitud;
  final double precioPorNoche;
  final double calificacionPromedio;
  final String? urlImagen;
  final int? categoriaId;
  final bool esDestacado;
  final DateTime? creadoEn;

  factory ModeloDestino.fromMap(Map<String, dynamic> map) {
    return ModeloDestino(
      id: map['id'] as String,
      nombre: map['name'] as String,
      descripcion: map['description'] as String,
      ubicacion: map['location'] as String,
      latitud: (map['latitude'] as num).toDouble(),
      longitud: (map['longitude'] as num).toDouble(),
      precioPorNoche: (map['price_per_night'] as num?)?.toDouble() ?? 0.0,
      calificacionPromedio: (map['rating_avg'] as num?)?.toDouble() ?? 0.0,
      urlImagen: map['image_url'] as String?,
      categoriaId: map['category_id'] as int?,
      esDestacado: map['is_featured'] as bool? ?? false,
      creadoEn: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': nombre,
      'description': descripcion,
      'location': ubicacion,
      'latitude': latitud,
      'longitude': longitud,
      'price_per_night': precioPorNoche,
      'rating_avg': calificacionPromedio,
      'image_url': urlImagen,
      'category_id': categoriaId,
      'is_featured': esDestacado,
      'created_at': creadoEn?.toIso8601String(),
    };
  }

  /// Obtiene la distancia en km desde una ubicación
  double distanciaDesde(double latitud, double longitud) {
    const double radioTierra = 6371; // km
    final double lat1 = this.latitud * 3.14159 / 180;
    final double lat2 = latitud * 3.14159 / 180;
    final double dLat = (latitud - this.latitud) * 3.14159 / 180;
    final double dLon = (longitud - this.longitud) * 3.14159 / 180;

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(1 - a), sqrt(a));

    return radioTierra * c;
  }
}
