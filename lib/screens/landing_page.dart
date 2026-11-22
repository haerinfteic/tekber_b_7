import 'package:flutter/material.dart';

/// PLACEHOLDER. Ganti dengan landing page asli dari anggota yang mengerjakannya.
/// Dipakai supaya alur Sign In / Sign Up sudah bisa dicoba.
class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static const routeName = '/landing';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FasorITS')),
      body: const Center(child: Text('Landing page (placeholder)')),
    );
  }
}
