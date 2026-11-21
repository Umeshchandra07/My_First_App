import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_application_1/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('End-to-end user registration and home navigation flow', (tester) async {
    // Launch app
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Enter user details in form fields
    await tester.enterText(find.byType(TextFormField).at(0), 'Jane Doe');
    await tester.enterText(find.byType(TextFormField).at(1), 'jane@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), '+1 9876543210');
    await tester.enterText(find.byType(TextFormField).at(3), 'Pass@123');
    await tester.enterText(find.byType(TextFormField).at(4), 'Mobile developer');

    // Tap 'Sign Up' button
    await tester.tap(find.text('Sign Up'));
    await tester.pumpAndSettle();

    // Verify navigation to Home Page and display of submitted details
    expect(find.text('Home Page'), findsOneWidget);
    expect(find.text('Welcome, Jane Doe!'), findsOneWidget);
    expect(find.text('Email: jane@example.com'), findsOneWidget);
  });
}
