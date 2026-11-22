import 'package:flutter_test/flutter_test.dart';

import 'package:tekber_b_7/main.dart';

void main() {
  testWidgets('Landing page smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FasorApp());
    await tester.pump();

    expect(find.text('FasorITS'), findsWidgets);
    expect(find.text('Cari Lapangan'), findsWidgets);
  });
}
