import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tekber_b_7/screens/auth/sign_in_screen.dart';

void main() {
  testWidgets('Sign In screen tampil', (WidgetTester tester) async {
    // Pakai MaterialApp polos (tanpa Google Fonts) supaya test tidak butuh internet.
    await tester.pumpWidget(const MaterialApp(home: SignInScreen()));

    expect(find.text('Email/NRP'), findsOneWidget);
    expect(find.text('Sign In with Google'), findsOneWidget);
  });
}
