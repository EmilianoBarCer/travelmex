import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _service = SupabaseService.instance;
  final GoTrueClient _auth = Supabase.instance.client.auth;

  UserProfile? _profile;
  bool _isLoading = true;
  String? _error;

  AuthProvider() {
    _initialize();
  }

  UserProfile? get profile => _profile;
  bool get isAuthenticated => _profile != null;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get userId => _profile?.id;

  Future<void> _initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final currentUser = _auth.currentSession?.user ?? _auth.currentUser;
      if (currentUser != null) {
        await _loadProfileForUser(currentUser);
      }
    } catch (e) {
      _error = _parseAuthError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authResponse = await _auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = _extractUser(authResponse);
      if (user == null) {
        throw const AuthException(
            'No se pudo iniciar sesión. Revisa tus credenciales.');
      }

      await _loadProfileForUser(user);
      return true;
    } catch (e) {
      _error = _parseAuthError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    String? name,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final authResponse = await _auth.signUp(
        email: email,
        password: password,
      );

      final user = _extractUser(authResponse);
      if (user == null) {
        throw const AuthException(
            'Registrado correctamente. Revisa tu correo para confirmar la cuenta.');
      }

      try {
        final profile = await _service.upsertProfile(
          userId: user.id,
          email: email,
          name: name,
          avatarUrl: avatarUrl,
        );
        _profile = profile;
      } catch (e) {
        if (_isMissingProfilesTable(e)) {
          _profile = UserProfile(
            id: user.id,
            email: email,
            name: name,
            avatarUrl: avatarUrl,
          );
        } else {
          rethrow;
        }
      }

      return true;
    } catch (e) {
      _error = _parseAuthError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _auth.signOut();
      _profile = null;
    } catch (e) {
      _error = _parseAuthError(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    if (_profile == null) return false;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedProfile = await _service.upsertProfile(
        userId: _profile!.id,
        email: _profile!.email,
        name: name ?? _profile!.name,
        avatarUrl: avatarUrl ?? _profile!.avatarUrl,
      );

      _profile = updatedProfile;
      return true;
    } catch (e) {
      if (_isMissingProfilesTable(e)) {
        _error =
            'La tabla "profiles" no existe. Ejecuta sql/schema.sql en Supabase para habilitar el perfil.';
        return false;
      }
      _error = _parseAuthError(e);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadProfileForUser(User user) async {
    try {
      final profile = await _service.fetchProfileByUserId(user.id);
      if (profile != null) {
        _profile = profile;
        return;
      }

      _profile = await _service.upsertProfile(
        userId: user.id,
        email: user.email ?? '',
        name: user.email?.split('@').first,
      );
    } catch (e) {
      if (_isMissingProfilesTable(e)) {
        _profile = UserProfile(
          id: user.id,
          email: user.email ?? '',
          name: user.email?.split('@').first,
          avatarUrl: null,
        );
        return;
      }
      rethrow;
    }
  }

  bool _isMissingProfilesTable(Object error) {
    final String message = error.toString().toLowerCase();
    return message.contains('la tabla "profiles"') ||
        message.contains('public.profiles');
  }

  User? _extractUser(dynamic authResponse) {
    return authResponse?.user ??
        authResponse?.session?.user ??
        (authResponse?.data is Map ? authResponse?.data['user'] : null);
  }

  String _parseAuthError(Object error) {
    if (error is AuthException) {
      return error.message;
    }
    if (error is PostgrestException) {
      return error.message;
    }

    final message = error.toString();
    if (message.contains('Invalid login credentials')) {
      return 'Correo o contraseña incorrectos.';
    }
    if (message.contains('duplicated email')) {
      return 'El correo ya está registrado. Por favor inicia sesión.';
    }
    return message;
  }
}
