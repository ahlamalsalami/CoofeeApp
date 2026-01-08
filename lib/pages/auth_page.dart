import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

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
    // After the first frame we can read the Auth provider to decide
    // which tab to show by default: if there are existing users show
    // the login tab (index 0), otherwise show signup (index 1).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<Auth>(context, listen: false);
      if (auth.hasUsers) {
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
    final auth = Provider.of<Auth>(context, listen: false);
    final ok = await auth.login(
      _loginEmail.text.trim(),
      _loginPassword.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم تسجيل الدخول')));
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  Future<void> _submitSignup() async {
    if (!(_signupKey.currentState?.validate() ?? false)) return;
    final auth = Provider.of<Auth>(context, listen: false);
    final ok = await auth.signup(
      _signupEmail.text.trim(),
      _signupPassword.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('تم إنشاء الحساب')));
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تسجيل / إنشاء حساب'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'دخول'), Tab(text: 'إنشاء')],
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
                    decoration: const InputDecoration(
                      labelText: 'البريد الإلكتروني',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        (v) =>
                            (v == null || v.isEmpty)
                                ? 'أدخل البريد الإلكتروني'
                                : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _loginPassword,
                    decoration: const InputDecoration(labelText: 'كلمة المرور'),
                    obscureText: true,
                    validator:
                        (v) =>
                            (v == null || v.length < 4)
                                ? 'الرمز قصير جداً'
                                : null,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _submitLogin,
                    child: const Text('دخول'),
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
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator:
                          (v) =>
                              (v == null || v.isEmpty)
                                  ? 'أدخل البريد الإلكتروني'
                                  : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _signupPassword,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور',
                      ),
                      obscureText: true,
                      validator:
                          (v) =>
                              (v == null || v.length < 6)
                                  ? 'أدخل 6 أحرف على الأقل'
                                  : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _signupConfirm,
                      decoration: const InputDecoration(
                        labelText: 'تأكيد كلمة المرور',
                      ),
                      obscureText: true,
                      validator:
                          (v) =>
                              (v != _signupPassword.text)
                                  ? 'كلمتا المرور غير متطابقتين'
                                  : null,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _submitSignup,
                      child: const Text('إنشاء حساب'),
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
