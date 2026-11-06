import 'dart:async';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../data/mock_data.dart';

class AuthService extends ChangeNotifier {
  SupabaseClient? get _supabase {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  StreamSubscription<AuthState>? _authSubscription;

  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserProfile? get currentUser => _currentUser;
  bool get isLoggedIn {
    final client = _supabase;
    return (client != null && client.auth.currentUser != null) || _currentUser != null;
  }

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  String? get currentUserId {
    final client = _supabase;
    return client?.auth.currentUser?.id ?? _currentUser?.id;
  }

  AuthService() {
    _initAuthListener();
  }

  void _initAuthListener() {
    try {
      final client = _supabase;
      if (client != null) {
        final session = client.auth.currentSession;
        if (session != null) {
          _fetchUserProfile(session.user.id, session.user.email);
        } else {
          _currentUser = null;
        }

        _authSubscription = client.auth.onAuthStateChange.listen((data) {
          final AuthChangeEvent event = data.event;
          final Session? sess = data.session;

          if (event == AuthChangeEvent.signedIn && sess != null) {
            _fetchUserProfile(sess.user.id, sess.user.email);
          } else if (event == AuthChangeEvent.signedOut) {
            _currentUser = null;
            notifyListeners();
          }
        });
      }
    } catch (e) {
      debugPrint('Supabase Auth init error: $e');
      _currentUser = MockData.defaultUser;
    }
  }

  Future<void> _fetchUserProfile(String userId, String? email) async {
    final client = _supabase;
    if (client == null) return;

    try {
      // 1. Fetch profile
      final profileResponse = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      // 2. Fetch default address
      final addressResponse = await client
          .from('addresses')
          .select()
          .eq('user_id', userId)
          .order('is_default', ascending: false)
          .limit(1)
          .maybeSingle();

      if (profileResponse != null) {
        _currentUser = UserProfile.fromSupabase(
          profileResponse,
          email: email,
          addressMap: addressResponse,
        );
      } else {
        // Fallback default profile if table row hasn't been created yet
        _currentUser = UserProfile(
          id: userId,
          name: email?.split('@').first ?? 'Sahabat KEBUNIN',
          email: email ?? '',
          phone: addressResponse?['phone']?.toString() ?? '0812-3456-7890',
          address: addressResponse?['full_address']?.toString() ??
              'Jl. Kebon Jeruk Indah No. 12',
        );
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching user profile: $e');
      _currentUser = UserProfile(
        id: userId,
        name: email?.split('@').first ?? 'Sahabat KEBUNIN',
        email: email ?? '',
        phone: '0812-3456-7890',
        address: 'Jl. Kebon Jeruk Indah No. 12',
      );
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (email.trim().isEmpty || !email.contains('@')) {
      _errorMessage = 'Silakan masukkan alamat email yang valid.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    if (password.length < 6) {
      _errorMessage = 'Password minimal harus 6 karakter.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final client = _supabase;
      if (client != null) {
        final res = await client.auth.signInWithPassword(
          email: email.trim(),
          password: password,
        );

        if (res.user != null) {
          await _fetchUserProfile(res.user!.id, res.user!.email);
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
      _errorMessage = 'Gagal masuk. Periksa email dan password.';
      _isLoading = false;
      notifyListeners();
      return false;
    } on AuthException catch (e) {
      _errorMessage = _translateAuthError(e.message);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    String? phone,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (name.trim().isEmpty) {
      _errorMessage = 'Nama lengkap wajib diisi.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    if (email.trim().isEmpty || !email.contains('@')) {
      _errorMessage = 'Format email tidak valid.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    if (password.length < 6) {
      _errorMessage = 'Password minimal 6 karakter.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
    if (password != confirmPassword) {
      _errorMessage = 'Konfirmasi password tidak cocok.';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      final client = _supabase;
      if (client != null) {
        final res = await client.auth.signUp(
          email: email.trim(),
          password: password,
          data: {
            'full_name': name.trim(),
          },
        );

        final user = res.user;
        if (user != null) {
          // Create row in profiles table
          try {
            await client.from('profiles').upsert({
              'id': user.id,
              'full_name': name.trim(),
              'phone': phone?.trim().isNotEmpty == true
                  ? phone!.trim()
                  : '0812-3456-7890',
              'avatar_url':
                  'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
              'created_at': DateTime.now().toIso8601String(),
              'updated_at': DateTime.now().toIso8601String(),
            });
          } catch (profileError) {
            debugPrint('Error inserting initial profile: $profileError');
          }

          await _fetchUserProfile(user.id, user.email);
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }

      _errorMessage = 'Gagal mendaftarkan akun baru.';
      _isLoading = false;
      notifyListeners();
      return false;
    } on AuthException catch (e) {
      _errorMessage = _translateAuthError(e.message);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String postalCode,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userId = currentUserId;
      final client = _supabase;
      if (userId != null && client != null) {
        // 1. Update profiles table
        await client.from('profiles').upsert({
          'id': userId,
          'full_name': name.trim(),
          'phone': phone.trim(),
          'updated_at': DateTime.now().toIso8601String(),
        });

        // 2. Upsert addresses table
        final existingAddress = await client
            .from('addresses')
            .select('id')
            .eq('user_id', userId)
            .limit(1)
            .maybeSingle();

        if (existingAddress != null) {
          await client.from('addresses').update({
            'recipient_name': name.trim(),
            'phone': phone.trim(),
            'full_address': address.trim(),
            'city': city.trim(),
            'postal_code': postalCode.trim(),
            'is_default': true,
          }).eq('id', existingAddress['id']);
        } else {
          await client.from('addresses').insert({
            'user_id': userId,
            'recipient_name': name.trim(),
            'phone': phone.trim(),
            'full_address': address.trim(),
            'city': city.trim(),
            'postal_code': postalCode.trim(),
            'is_default': true,
          });
        }
      }

      // Update local memory
      if (_currentUser != null) {
        _currentUser = _currentUser!.copyWith(
          name: name.trim(),
          phone: phone.trim(),
          address: address.trim(),
          city: city.trim(),
          postalCode: postalCode.trim(),
        );
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error updating profile: $e');
      _errorMessage = 'Gagal memperbarui profil: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    try {
      final client = _supabase;
      if (client != null) {
        await client.auth.signOut();
      }
    } catch (e) {
      debugPrint('Error logging out: $e');
    } finally {
      _currentUser = null;
      notifyListeners();
    }
  }

  String _translateAuthError(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('invalid login credentials')) {
      return 'Email atau password yang Anda masukkan salah.';
    } else if (lower.contains('user already registered')) {
      return 'Email sudah terdaftar. Silakan login atau gunakan email lain.';
    } else if (lower.contains('network') || lower.contains('connection')) {
      return 'Gagal terhubung ke server. Periksa koneksi internet Anda.';
    }
    return message;
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
