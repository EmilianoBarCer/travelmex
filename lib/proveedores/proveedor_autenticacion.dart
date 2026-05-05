import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../modelos/modelo_usuario.dart';
import '../servicios/servicio_supabase.dart';

class ProveedorAutenticacion extends ChangeNotifier {
  final SupabaseService _servicio = SupabaseService.instancia;
  final GoTrueClient _auth = Supabase.instance.client.auth;

  ModeloUsuario? _usuario;
  bool _cargando = true;
  String? _error;

  ProveedorAutenticacion() {
    _inicializar();
  }

  ModeloUsuario? get usuario => _usuario;
  bool get estaAutenticado => _usuario != null;
  bool get cargando => _cargando;
  String? get error => _error;
  String? get idUsuario => _usuario?.id;

  Future<void> _inicializar() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final sesionActual = _auth.currentSession;
      final usuarioActual = sesionActual?.user ?? _auth.currentUser;

      if (usuarioActual != null) {
        await _cargarPerfilUsuario(usuarioActual);
      }
    } catch (e) {
      _error = _analizarErrorAutenticacion(e);
      debugPrint('Error en inicialización: $_error');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final respuestaAuth = await _auth.signInWithPassword(
        email: correo,
        password: contrasena,
      );

      if (respuestaAuth.user == null) {
        throw AuthException('No se pudo iniciar sesión. Revisa tus credenciales.');
      }

      await _cargarPerfilUsuario(respuestaAuth.user!);
      return true;
    } catch (e) {
      _error = _analizarErrorAutenticacion(e);
      debugPrint('Error al iniciar sesión: $_error');
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> registrarse({
    required String correo,
    required String contrasena,
    String? nombre,
    String? avatarUrl,
  }) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      // 1. Crear cuenta en Supabase Auth
      final respuestaRegistro = await _auth.signUp(
        email: correo,
        password: contrasena,
      );

      if (respuestaRegistro.user == null) {
        throw AuthException(
            'Registrado correctamente. Revisa tu correo para confirmar la cuenta.');
      }

      // 2. Crear perfil en BD
      try {
        final perfil = await _servicio.crearOActualizarPerfil(
          idUsuario: respuestaRegistro.user!.id,
          correo: correo,
          nombre: nombre,
          avatarUrl: avatarUrl,
        );
        _usuario = perfil;
      } catch (e) {
        // Si falla la creación del perfil, al menos guardamos el usuario
        debugPrint('Error al crear perfil: $e');
        _usuario = ModeloUsuario(
          id: respuestaRegistro.user!.id,
          email: correo,
          nombre: nombre,
          avatarUrl: avatarUrl,
        );
      }

      return true;
    } catch (e) {
      _error = _analizarErrorAutenticacion(e);
      debugPrint('Error al registrarse: $_error');
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> cerrarSesion() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.signOut();
      _usuario = null;
      debugPrint('Sesión cerrada exitosamente');
    } catch (e) {
      _error = _analizarErrorAutenticacion(e);
      debugPrint('Error al cerrar sesión: $_error');
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<bool> actualizarPerfil({
    String? nombre,
    String? bio,
    String? telefono,
    String? avatarUrl,
  }) async {
    if (_usuario == null) return false;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      final perfilActualizado = await _servicio.crearOActualizarPerfil(
        idUsuario: _usuario!.id,
        correo: _usuario!.email,
        nombre: nombre ?? _usuario!.nombre,
        avatarUrl: avatarUrl ?? _usuario!.avatarUrl,
        bio: bio ?? _usuario!.bio,
        telefono: telefono ?? _usuario!.telefono,
      );

      _usuario = perfilActualizado;
      debugPrint('Perfil actualizado exitosamente');
      return true;
    } catch (e) {
      _error = _analizarErrorAutenticacion(e);
      debugPrint('Error al actualizar perfil: $_error');
      return false;
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> _cargarPerfilUsuario(User usuarioAuth) async {
    try {
      final perfil = await _servicio.obtenerPerfilPorId(usuarioAuth.id);
      _usuario = perfil;
      debugPrint('Perfil cargado: ${perfil.nombre}');
    } catch (e) {
      // Si no existe el perfil, crear uno
      debugPrint('Perfil no encontrado, creando uno nuevo');
      _usuario = ModeloUsuario(
        id: usuarioAuth.id,
        email: usuarioAuth.email ?? '',
      );
    }
  }

  String _analizarErrorAutenticacion(dynamic error) {
    if (error is AuthException) {
      if (error.message.contains('Invalid login credentials')) {
        return 'Correo o contraseña incorrectos';
      } else if (error.message.contains('User already registered')) {
        return 'Este correo ya está registrado';
      } else if (error.message.contains('weak_password')) {
        return 'La contraseña es muy débil (mín. 6 caracteres)';
      }
      return error.message;
    }
    return 'Error de autenticación: $error';
  }
}
