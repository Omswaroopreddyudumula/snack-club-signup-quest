import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:snack_club/main.dart';

Future<void> submit(WidgetTester tester) async {
  final button = find.widgetWithText(FilledButton, 'Sign Up');
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pump();
}

void main() {
  testWidgets('required fields reject empty and whitespace input', (
    tester,
  ) async {
    await tester.pumpWidget(const SnackClubApp());
    await submit(tester);
    expect(find.text('Please enter your full name.'), findsOneWidget);
    expect(find.text('Please enter your email address.'), findsOneWidget);
    expect(find.text('Please enter a password.'), findsOneWidget);
    final fields = find.byType(TextFormField);
    for (var i = 0; i < 3; i++) {
      await tester.enterText(fields.at(i), '      ');
    }
    await submit(tester);
    expect(find.text('Please enter a password.'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('invalid email and short password fail; valid form succeeds', (
    tester,
  ) async {
    await tester.pumpWidget(const SnackClubApp());
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Snack Friend');
    await tester.enterText(fields.at(1), 'bad@email');
    await tester.enterText(fields.at(2), '12345');
    await submit(tester);
    expect(find.text('Please enter a valid email address.'), findsOneWidget);
    expect(find.text('Use at least six characters.'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    await tester.enterText(fields.at(1), 'friend@example.com');
    await tester.enterText(fields.at(2), '123456');
    await submit(tester);
    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsOneWidget,
    );
    expect(
      tester.widget<SnackBar>(find.byType(SnackBar)).backgroundColor,
      Colors.green,
    );
    final password = tester.widget<EditableText>(
      find.byType(EditableText).at(2),
    );
    expect(password.obscureText, isTrue);
    expect(password.autocorrect, isFalse);
    expect(password.enableSuggestions, isFalse);
  });

  testWidgets('tips load, disable requests, stay short, and repeat in order', (
    tester,
  ) async {
    await tester.pumpWidget(const SnackClubApp());
    const tips = [
      'Use a long password that you do not use for another account.',
      'A few unrelated words can make a password easier to remember.',
      'Avoid using your name or birthday in your password.',
    ];
    for (var i = 0; i < 4; i++) {
      final button = find.widgetWithText(OutlinedButton, 'Get a signup tip');
      await tester.ensureVisible(button);
      await tester.tap(button);
      await tester.pump();
      expect(
        tester.widget<OutlinedButton>(find.byType(OutlinedButton)).onPressed,
        isNull,
      );
      expect(find.text('Loading tip…'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 600));
      final result = tester
          .widget<Text>(find.byKey(const Key('signup-tip')))
          .data!;
      expect(result, tips[i % 3]);
      expect(result.length, lessThanOrEqualTo(240));
    }
  });

  testWidgets('disposing while a tip loads is safe', (tester) async {
    await tester.pumpWidget(const SnackClubApp());
    final button = find.text('Get a signup tip');
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 600));
    expect(tester.takeException(), isNull);
  });

  testWidgets('small screen with keyboard inset can scroll to signup', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(const SnackClubApp());
    await submit(tester);
    expect(find.text('Please enter your full name.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
