import 'package:flutter/material.dart';

import '../../core/account_styles.dart';
import '../../core/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/fasor_app_bar.dart';
import '../../widgets/section_card.dart';
import 'delete_account_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  static const routeName = '/account';

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser ?? AuthService.demoUser;

    return Scaffold(
      appBar: fasorAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Akun Saya', style: AccountText.title),
            const SizedBox(height: 4),
            const Text('Kelola informasi akun FasorITS kamu.', style: AccountText.body),
            const SizedBox(height: 20),
            SectionCard(
              title: 'Informasi Akun',
              child: Column(
                children: [
                  _InfoRow(label: 'Nama', value: user.name),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _InfoRow(label: 'NRP', value: user.nrp),
                  const Divider(height: 1, color: AppColors.cardBorder),
                  _InfoRow(label: 'Email', value: user.email),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Peringatan!',
              headerColor: AccountColors.dangerSoft,
              borderColor: AccountColors.dangerBorder,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Hapus akun', style: AccountText.label),
                  const SizedBox(height: 4),
                  const Text(
                    'Menghapus akun akan menghapus seluruh data kamu, '
                    'termasuk riwayat pesanan. Tindakan ini tidak dapat dibatalkan.',
                    style: AccountText.body,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, DeleteAccountScreen.routeName),
                      icon: const Icon(Icons.delete_outline),
                      label: const Text('Hapus Akun'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 72, child: Text(label, style: AccountText.body)),
          Expanded(child: Text(value, style: AccountText.label)),
        ],
      ),
    );
  }
}
