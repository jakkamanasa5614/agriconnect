import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agriconnect/main.dart';

void main() {
  testWidgets('Verify AgriConnect app loads and shows login screen',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AgriConnectApp());

    // Wait for any async frames to complete
    await tester.pumpAndSettle();

    // Check that the LOGIN tab is visible
    expect(find.text('LOGIN'), findsOneWidget);

    // Optionally, check for form fields or buttons on the screen
    expect(find.byType(TextField), findsWidgets);
    expect(find.byType(ElevatedButton), findsWidgets);
  });
}
