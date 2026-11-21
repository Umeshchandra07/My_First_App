import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_application_1/auth_bloc.dart';
import 'package:flutter_application_1/auth_repository.dart';
import 'package:flutter_application_1/signup_screen.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  testWidgets('SignUpScreen renders all input fields and button', (WidgetTester tester) async {
    final mockRepo = MockAuthRepository();
    
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (context) => AuthBloc(authRepository: mockRepo),
          child: const SignUpScreen(),
        ),
      ),
    );

    expect(find.byType(TextFormField), findsNWidgets(5)); // Name, Email, Phone, Password, Bio
    expect(find.text('Create Account'), findsOneWidget);
  });
}
