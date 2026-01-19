/// هندسة MVC - طبقة العرض
///
/// يعرض هذا العرض شاشة المصادقة بنمط MVC.
/// يعرض نماذج تسجيل الدخول/الاشتراك ويتفاعل مع AuthController.
///
/// جزء من بنية MVC حيث:
/// - النموذج: هياكل البيانات في /models/
/// - عرض: مكونات واجهة المستخدم (هذا الملف)
/// - وحدة التحكم: منطق الأعمال في /وحدات التحكم/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late AuthController authController;

  final _loginKey = GlobalKey<FormState>();
  final _signupKey = GlobalKey<FormState>();

  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();

  final _signupEmail = TextEditingController();
  final _signupPassword = TextEditingController();
  final _signupConfirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    authController = Get.find<AuthController>();
    
    // After the first frame we can read the Auth controller to decide
    // which tab to show by default: if there are existing users show
    // the login tab (index 0), otherwise show signup (index 1).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authController.hasUsers) {
        _tabController.index = 0;
      } else {
        _tabController.index = 1;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmail.dispose();
    _loginPassword.dispose();
    _signupEmail.dispose();
    _signupPassword.dispose();
    _signupConfirm.dispose();
    super.dispose();
  }

  Future<void> _submitLogin() async {
    if (!(_loginKey.currentState?.validate() ?? false)) return;
    
    final ok = await authController.login(
      _loginEmail.text.trim(),
      _loginPassword.text.trim(),
    );
    
    if (ok) {
      Get.snackbar(
        'login_success'.tr,
        'login_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed('/');
    }
  }

  Future<void> _submitSignup() async {
    if (!(_signupKey.currentState?.validate() ?? false)) return;
    
    final ok = await authController.signup(
      _signupEmail.text.trim(),
      _signupPassword.text.trim(),
    );
    
    if (ok) {
      Get.snackbar(
        'signup_success'.tr,
        'signup_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.offAllNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('auth_title'.tr),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'login_tab'.tr),
            Tab(text: 'signup_tab'.tr),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _loginKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _loginEmail,
                    decoration: InputDecoration(
                      labelText: 'email_label'.tr,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        (v == null || v.isEmpty) ? 'enter_email'.tr : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _loginPassword,
                    decoration: InputDecoration(labelText: 'password_label'.tr),
                    obscureText: true,
                    validator: (v) =>
                        (v == null || v.length < 4) ? 'password_too_short'.tr : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitLogin,
                    child: Text('login_button'.tr),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _signupKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: _signupEmail,
                      decoration: InputDecoration(
                        labelText: 'email_label'.tr,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'enter_email'.tr : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _signupPassword,
                      decoration: InputDecoration(
                        labelText: 'password_label'.tr,
                      ),
                      obscureText: true,
                      validator: (v) =>
                          (v == null || v.length < 6) ? 'min_six_chars'.tr : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _signupConfirm,
                      decoration: InputDecoration(
                        labelText: 'confirm_password_label'.tr,
                      ),
                      obscureText: true,
                      validator: (v) =>
                          (v != _signupPassword.text) ? 'passwords_not_match'.tr : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitSignup,
                      child: Text('signup_button'.tr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}