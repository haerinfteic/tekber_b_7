import 'package:flutter/material.dart';

import '../../core/account_styles.dart';
import '../../core/app_theme.dart';
import '../../widgets/fasor_app_bar.dart';
import '../auth/sign_in_screen.dart';

class DeleteSuccessScreen extends StatelessWidget {
  const DeleteSuccessScreen({super.key});

  static const routeName = '/delete-success';

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: fasorAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AccountColors.successSoft,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AccountColors.success,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 24),
                const Text('Akun berhasil dihapus', style: AccountText.title),
                const SizedBox(height: 8),
                const Text(
                  'Terima kasih sudah menggunakan FasorITS. '
                  'Seluruh data akun kamu telah dihapus.',
                  textAlign: TextAlign.center,
                  style: AccountText.body,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    SignInScreen.routeName,
                    (route) => false,
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('Kembali ke Sign In'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
