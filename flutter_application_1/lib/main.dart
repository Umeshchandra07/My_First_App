import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_bloc.dart';
import 'auth_repository.dart';
import 'signup_screen.dart';
import 'app_strings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: globalLanguageNotifier,
      builder: (context, currentLang, child) {
        return MaterialApp(
          key: ValueKey(currentLang),
          debugShowCheckedModeBanner: false,
          title: 'Account Creation App',
          theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
          home: BlocProvider(
            create: (context) => AuthBloc(authRepository: AuthRepository()),
            child: const SignUpScreen(),
          ),
        );
      },
    );
  }
}
