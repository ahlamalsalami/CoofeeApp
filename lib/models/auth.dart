import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  bool _isAuth = false;
  String? _email;

  // users stored as map email -> {"username":..., "password":...}
  final Map<String, Map<String, String>> _users = {};

  static const _kUsersKey = 'ah_users';
  static const _kCurrentUserKey = 'ah_current_user';

  bool get isAuth => _isAuth;
  String? get email => _email;
  bool get hasUsers => _users.isNotEmpty;

  // Load users and current session from SharedPreferences
  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getString(_kUsersKey);
    if (usersJson != null && usersJson.isNotEmpty) {
      try {
        final Map<String, dynamic> data =
            json.decode(usersJson) as Map<String, dynamic>;
        _users.clear();
        data.forEach((key, value) {
          if (value is Map<String, dynamic>) {
            _users[key] = {
              'username': value['username']?.toString() ?? '',
              'password': value['password']?.toString() ?? '',
            };
          }
        });
      } catch (_) {
        // ignore parse errors
      }
    }
    final current = prefs.getString(_kCurrentUserKey);
    if (current != null && _users.containsKey(current)) {
      _isAuth = true;
      _email = current;
    } else {
      _isAuth = false;
      _email = null;
    }
    notifyListeners();
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_users);
    await prefs.setString(_kUsersKey, encoded);
  }

  Future<void> _setCurrentUser(String? email) async {
    final prefs = await SharedPreferences.getInstance();
    if (email == null) {
      await prefs.remove(_kCurrentUserKey);
    } else {
      await prefs.setString(_kCurrentUserKey, email);
    }
  }

  // Sign up a new user (simple: email, username, password). Returns false if email exists.
  Future<bool> signup(String email, String password, {String? username}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final key = email.trim().toLowerCase();
    if (_users.containsKey(key)) return false;
    _users[key] = {'username': username?.trim() ?? '', 'password': password};
    await _saveUsers();
    _isAuth = true;
    _email = key;
    await _setCurrentUser(key);
    notifyListeners();
    return true;
  }

  // Login checks stored credentials.
  Future<bool> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final key = email.trim().toLowerCase();
    final user = _users[key];
    if (user == null) return false;
    if (user['password'] != password) return false;
    _isAuth = true;
    _email = key;
    await _setCurrentUser(key);
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _isAuth = false;
    _email = null;
    await _setCurrentUser(null);
    notifyListeners();
  }
}
