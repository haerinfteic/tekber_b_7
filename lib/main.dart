import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// URL & publishable key aman ada di aplikasi (data dilindungi RLS).
// JANGAN pernah menaruh password database / secret / service_role key di sini.
const supabaseUrl = 'https://qzjmycricikgjrpikgos.supabase.co';
const supabaseKey = 'sb_publishable_8xiori5nvuoloLrVp3fTEA_G6FgxtHk';

/// Lebar frame desain Figma (hi-fi). Seluruh UI digambar pada kanvas selebar ini
/// lalu diskalakan ke lebar layar, sehingga proporsinya sama dengan Figma.
const kDesignWidth = 780.0;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseKey);
  runApp(const FasorApp());
}

class FasorApp extends StatelessWidget {
  const FasorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FasorITS',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('FasorITS')),
        body: FutureBuilder(
          future: Supabase.instance.client.from('facilities').select('name'),
          builder: (context, snap) {
            if (snap.hasError) return Center(child: Text('Gagal: ${snap.error}'));
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            final rows = snap.data as List;
            return Center(child: Text('Terhubung ke Supabase: ${rows.length} fasilitas'));
          },
        ),
      ),
    );
  }
}