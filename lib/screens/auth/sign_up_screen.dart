import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/auth_widgets.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/sign-up';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // TODO(supabase): ganti dengan Supabase Auth (signUp) kalau backend siap.
    // Untuk sekarang anggap berhasil dan lanjut ke landing page.
    Navigator.of(context).pushReplacementNamed('/landing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavbar(
        showOrderHistory: true,
        showSignInButton: true,
        onSignIn: () => Navigator.of(context).pushReplacementNamed('/sign-in'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 32),
              child: AuthCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textDark,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Create your account to start booking facilities.',
                        style: TextStyle(fontSize: 16, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 32),
                      AuthTextField(
                        label: 'Full Name',
                        hint: 'John Doe',
                        controller: _nameController,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Nama lengkap wajib diisi' : null,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: 'NRP/Email',
                        hint: 'nrp@its.ac.id',
                        controller: _identifierController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.username],
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'NRP atau email wajib diisi' : null,
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: 'Password',
                        hint: '••••••••',
                        controller: _passwordController,
                        isPassword: true,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Password wajib diisi';
                          if (v.length < 8) return 'Password minimal 8 karakter';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      AuthTextField(
                        label: 'Confirm Password',
                        hint: '••••••••',
                        controller: _confirmController,
                        isPassword: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Konfirmasi password wajib diisi';
                          if (v != _passwordController.text) return 'Password tidak sama';
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(label: 'Sign Up', onPressed: _submit),
                      const SizedBox(height: 32),
                      const OrDivider(),
                      const SizedBox(height: 32),
                      GoogleButton(
                        label: 'Sign Up with Google',
                        onPressed: () => _showComingSoon('Sign up dengan Google menyusul setelah Supabase siap.'),
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(fontSize: 16, color: AppColors.textBody),
                          ),
                          InkWell(
                            onTap: () => Navigator.of(context).pushReplacementNamed('/sign-in'),
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
