import 'package:flutter/material.dart';

import '../../core/account_styles.dart';
import '../../core/app_theme.dart';
import '../../services/auth_service.dart';
import '../../widgets/fasor_app_bar.dart';
import '../../widgets/section_card.dart';
import 'delete_success_screen.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  static const routeName = '/delete-account';

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final _passwordController = TextEditingController();
  bool _confirmed = false;
  bool _obscure = true;
  bool _loading = false;
  String? _error;

  bool get _canSubmit =>
      _confirmed && _passwordController.text.isNotEmpty && !_loading;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _onDeletePressed() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus akun secara permanen?'),
        content: const Text(
          'Seluruh data akun kamu akan dihapus dan tidak bisa dikembalikan.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Ya, Hapus'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await AuthService.instance.deleteAccount(
        password: _passwordController.text,
      );
      if (!mounted) return;
      Navigator.of(context).pushNamedAndRemoveUntil(
        DeleteSuccessScreen.routeName,
        (route) => false,
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.message;
      });
    }
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(4),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: fasorAppBar(
        actionLabel: 'Kembali',
        onAction: _loading ? null : () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _WarningBanner(
              text: 'Tindakan ini permanen dan tidak dapat dibatalkan.',
            ),
            const SizedBox(height: 16),
            const SectionCard(
              title: 'Hapus Akun',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data yang akan dihapus', style: AccountText.label),
                  SizedBox(height: 8),
                  _BulletRow(
                    icon: Icons.person_outline,
                    text: 'Profil akun (nama, NRP, dan email)',
                  ),
                  _BulletRow(
                    icon: Icons.receipt_long_outlined,
                    text: 'Riwayat pesanan dan bukti pembayaran',
                  ),
                  _BulletRow(
                    icon: Icons.star_outline,
                    text: 'Ulasan dan lapangan favorit',
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Pesanan yang belum dibayar akan dibatalkan otomatis.',
                    style: AccountText.body,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SectionCard(
              title: 'Konfirmasi',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Password', style: AccountText.label),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscure,
                    enabled: !_loading,
                    onChanged: (_) => setState(() => _error = null),
                    decoration: InputDecoration(
                      hintText: 'Masukkan password untuk konfirmasi',
                      hintStyle: AccountText.hint,
                      errorText: _error,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: _border(AppColors.inputBorder),
                      enabledBorder: _border(AppColors.inputBorder),
                      disabledBorder: _border(AppColors.cardBorder),
                      focusedBorder: _border(AppColors.primary, width: 2),
                      errorBorder: _border(AppColors.error),
                      focusedErrorBorder: _border(AppColors.error, width: 2),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscure
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  CheckboxListTile(
                    value: _confirmed,
                    onChanged: _loading
                        ? null
                        : (value) => setState(() => _confirmed = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: const Text(
                      'Saya memahami bahwa akun dan seluruh data saya '
                      'akan dihapus permanen.',
                      style: AccountText.body,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _canSubmit ? _onDeletePressed : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Hapus Akun Saya'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _loading ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textBody,
                side: const BorderSide(color: AppColors.cardBorder),
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: const Text('Batal'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AccountColors.dangerSoft,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AccountColors.dangerDark,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AccountColors.dangerDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AccountText.body)),
        ],
      ),
    );
  }
}
