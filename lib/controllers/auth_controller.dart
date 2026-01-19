/// بنية MVC - طبقة التحكم
///
/// تعالج وحدة التحكم هذه منطق أعمال المصادقة في نمط MVC.
/// يدير حالة المستخدم، ووظيفة تسجيل الدخول/الخروج، واستمرارية بيانات المستخدم.
///
/// جزء من بنية MVC حيث:
/// - النموذج: هياكل البيانات في /models/
/// - العرض: مكونات واجهة المستخدم في /views/
/// - وحدة التحكم: منطق الأعمال (هذا الملف)

import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  var isAuth = false.obs;
  var email = ''.obs;

  // users stored as map email -> {"username":..., "password":...}
  final Map<String, Map<String, String>> _users = {};

  static const _kUsersKey = 'ah_users';
  static const _kCurrentUserKey = 'ah_current_user';

  bool get hasUsers => _users.isNotEmpty;

  @override
  void onInit() {
    super.onInit();
    loadFromPrefs();
  }

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
      isAuth.value = true;
      email.value = current;
    } else {
      isAuth.value = false;
      email.value = '';
    }
  }

  Future<void> _saveUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = json.encode(_users);
    await prefs.setString(_kUsersKey, encoded);
  }

  Future<void> _setCurrentUser(String? emailValue) async {
    final prefs = await SharedPreferences.getInstance();
    if (emailValue == null) {
      await prefs.remove(_kCurrentUserKey);
    } else {
      await prefs.setString(_kCurrentUserKey, emailValue);
    }
  }

  // Sign up a new user (simple: email, username, password). Returns false if email exists.
  Future<bool> signup(String emailValue, String password, {String? username}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final key = emailValue.trim().toLowerCase();
    if (_users.containsKey(key)) return false;
    _users[key] = {'username': username?.trim() ?? '', 'password': password};
    await _saveUsers();
    isAuth.value = true;
    this.email.value = key;
    await _setCurrentUser(key);
    update();
    return true;
  }

  // Login checks stored credentials.
  Future<bool> login(String emailValue, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final key = emailValue.trim().toLowerCase();
    final user = _users[key];
    if (user == null) return false;
    if (user['password'] != password) return false;
    isAuth.value = true;
    this.email.value = key;
    await _setCurrentUser(key);
    update();
    return true;
  }

  Future<void> logout() async {
    isAuth.value = false;
    email.value = '';
    await _setCurrentUser(null);
    update();
  }
}