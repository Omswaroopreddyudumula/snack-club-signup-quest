import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:snack_club/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Android signup and local tip smoke test', (tester) async {
    await tester.pumpWidget(const SnackClubApp());
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Demo Student');
    await tester.enterText(fields.at(1), 'demo@example.com');
    await tester.enterText(fields.at(2), 'snacks123');
    final signup = find.text('Sign Up');
    await tester.ensureVisible(signup);
    await tester.tap(signup);
    await tester.pumpAndSettle();
    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsOneWidget,
    );
    final tip = find.text('Get a signup tip');
    await tester.ensureVisible(tip);
    await tester.tap(tip);
    await tester.pumpAndSettle();
    expect(
      find.text('Use a long password that you do not use for another account.'),
      findsOneWidget,
    );
  });
}
