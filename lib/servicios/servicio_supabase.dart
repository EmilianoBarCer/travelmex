import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../modelos/modelo_usuario.dart';
import '../modelos/modelo_destino.dart';
import '../modelos/modelo_resena.dart';

/// 🔌 Servicio Principal de Supabase
class SupabaseService {
  static final SupabaseService _instancia = SupabaseService._interno();

  factory SupabaseService() {
    return _instancia;
  }

  SupabaseService._interno();

  static SupabaseService get instancia => _instancia;

  SupabaseClient get _cliente => Supabase.instance.client;

  // ============ PERFILES ============

  /// Obtener perfil por ID
  Future<ModeloUsuario> obtenerPerfilPorId(String idUsuario) async {
    try {
      final respuesta = await _cliente
          .from('profiles')
          .select()
          .eq('id', idUsuario)
          .single();

      return ModeloUsuario.fromMap(respuesta);
    } catch (e) {
      debugPrint('Error obteniendo perfil: $e');
      rethrow;
    }
  }

  /// Crear o actualizar perfil
  Future<ModeloUsuario> crearOActualizarPerfil({
    required String idUsuario,
    required String correo,
    String? nombre,
    String? avatarUrl,
    String? bio,
    String? telefono,
  }) async {
    try {
      final datosUpsert = {
        'id': idUsuario,
        'email': correo,
        'name': nombre,
        'avatar_url': avatarUrl,
        'bio': bio,
        'phone': telefono,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final respuesta = await _cliente
          .from('profiles')
          .upsert(datosUpsert)
          .select()
          .single();

      debugPrint('Perfil actualizado: $idUsuario');
      return ModeloUsuario.fromMap(respuesta);
    } catch (e) {
      debugPrint('Error actualizando perfil: $e');
      rethrow;
    }
  }

  // ============ DESTINOS ============

  /// Obtener todos los destinos
  Future<List<ModeloDestino>> obtenerDestinos({
    int limite = 50,
    int offset = 0,
  }) async {
    try {
      final respuesta = await _cliente
          .from('destinations')
          .select()
          .limit(limite)
          .range(offset, offset + limite - 1);

      return (respuesta as List)
          .map((item) => ModeloDestino.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error obteniendo destinos: $e');
      return [];
    }
  }

  /// Obtener destinos destacados
  Future<List<ModeloDestino>> obtenerDestinosDestacados() async {
    try {
      final respuesta = await _cliente
          .from('destinations')
          .select()
          .eq('is_featured', true)
          .limit(10);

      return (respuesta as List)
          .map((item) => ModeloDestino.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error obteniendo destinos destacados: $e');
      return [];
    }
  }

  /// Obtener destinos por categoría
  Future<List<ModeloDestino>> obtenerDestinosPorCategoria(int idCategoria) async {
    try {
      final respuesta = await _cliente
          .from('destinations')
          .select()
          .eq('category_id', idCategoria);

      return (respuesta as List)
          .map((item) => ModeloDestino.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error obteniendo destinos por categoría: $e');
      return [];
    }
  }

  /// Obtener destino por ID
  Future<ModeloDestino> obtenerDestinoPorId(String idDestino) async {
    try {
      final respuesta = await _cliente
          .from('destinations')
          .select()
          .eq('id', idDestino)
          .single();

      return ModeloDestino.fromMap(respuesta);
    } catch (e) {
      debugPrint('Error obteniendo destino: $e');
      rethrow;
    }
  }

  // ============ RESEÑAS ============

  /// Obtener reseñas de un destino
  Future<List<ModeloResena>> obtenerResenasPorDestino(String idDestino) async {
    try {
      final respuesta = await _cliente
          .from('reviews')
          .select()
          .eq('destination_id', idDestino)
          .order('created_at', ascending: false);

      return (respuesta as List)
          .map((item) => ModeloResena.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error obteniendo reseñas: $e');
      return [];
    }
  }

  /// Obtener reseñas de un usuario
  Future<List<ModeloResena>> obtenerResenasPorUsuario(String idUsuario) async {
    try {
      final respuesta = await _cliente
          .from('reviews')
          .select()
          .eq('user_id', idUsuario)
          .order('created_at', ascending: false);

      return (respuesta as List)
          .map((item) => ModeloResena.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error obteniendo reseñas del usuario: $e');
      return [];
    }
  }

  /// Crear nueva reseña
  Future<ModeloResena> crearResena({
    required String idDestino,
    required String idUsuario,
    required String comentario,
    required int calificacion,
  }) async {
    try {
      final datosInsert = {
        'destination_id': idDestino,
        'user_id': idUsuario,
        'comment': comentario,
        'rating': calificacion,
      };

      final respuesta = await _cliente
          .from('reviews')
          .insert(datosInsert)
          .select()
          .single();

      debugPrint('Reseña creada para destino: $idDestino');
      return ModeloResena.fromMap(respuesta);
    } catch (e) {
      debugPrint('Error creando reseña: $e');
      rethrow;
    }
  }

  /// Actualizar reseña
  Future<ModeloResena> actualizarResena({
    required String idResena,
    required String comentario,
    required int calificacion,
  }) async {
    try {
      final datosUpdate = {
        'comment': comentario,
        'rating': calificacion,
      };

      final respuesta = await _cliente
          .from('reviews')
          .update(datosUpdate)
          .eq('id', idResena)
          .select()
          .single();

      debugPrint('Reseña actualizada: $idResena');
      return ModeloResena.fromMap(respuesta);
    } catch (e) {
      debugPrint('Error actualizando reseña: $e');
      rethrow;
    }
  }

  /// Eliminar reseña
  Future<void> eliminarResena(String idResena) async {
    try {
      await _cliente.from('reviews').delete().eq('id', idResena);
      debugPrint('Reseña eliminada: $idResena');
    } catch (e) {
      debugPrint('Error eliminando reseña: $e');
      rethrow;
    }
  }

  // ============ CATEGORÍAS ============

  /// Obtener todas las categorías
  Future<List<Map<String, dynamic>>> obtenerCategorias() async {
    try {
      final respuesta = await _cliente.from('categories').select();
      return List<Map<String, dynamic>>.from(respuesta);
    } catch (e) {
      debugPrint('Error obteniendo categorías: $e');
      return [];
    }
  }
}
