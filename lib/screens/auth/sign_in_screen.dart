import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/auth_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showComingSoon(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // TODO(supabase): ganti dengan Supabase Auth (signInWithPassword) kalau
    // backend sudah siap. Untuk sekarang langsung ke landing page.
    Navigator.of(context).pushReplacementNamed('/landing');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppNavbar(),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Align(
                // Di desain kartu sedikit di atas tengah layar.
                alignment: const Alignment(0, -0.3),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: AuthCard(
                    borderColor: const Color(0xFFE5E7EB),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Sign In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textDark,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Access your sports facility dashboard',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16, color: AppColors.textMuted),
                          ),
                          const SizedBox(height: 28),
                          AuthTextField(
                            label: 'Email/NRP',
                            hint: 'Enter your email or NRP',
                            controller: _identifierController,
                            fieldHeight: 42,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            autofillHints: const [AutofillHints.username],
                            validator: (v) =>
                                (v == null || v.trim().isEmpty) ? 'Email atau NRP wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),
                          AuthTextField(
                            label: 'Password',
                            hint: '••••••••',
                            controller: _passwordController,
                            isPassword: true,
                            fieldHeight: 42,
                            textInputAction: TextInputAction.done,
                            autofillHints: const [AutofillHints.password],
                            onSubmitted: (_) => _submit(),
                            trailingLabel: InkWell(
                              onTap: () => _showComingSoon('Fitur lupa password menyusul setelah Supabase siap.'),
                              child: const Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Password wajib diisi' : null,
                          ),
                          const SizedBox(height: 24),
                          PrimaryButton(label: 'Sign In', height: 36, radius: 4, onPressed: _submit),
                          const SizedBox(height: 24),
                          const OrDivider(),
                          const SizedBox(height: 24),
                          GoogleButton(
                            label: 'Sign In with Google',
                            height: 39,
                            radius: 4,
                            borderColor: AppColors.divider,
                            onPressed: () => _showComingSoon('Sign in dengan Google menyusul setelah Supabase siap.'),
                          ),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(fontSize: 14, color: AppColors.textBody),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).pushReplacementNamed('/sign-up'),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
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
        ),
      ),
    );
  }
}
