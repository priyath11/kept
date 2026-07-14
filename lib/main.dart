import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'app_theme.dart';
import 'firebase_options.dart';
import 'views/auth/sign_up_screen.dart';
import 'views/home/main_screen.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterNativeSplash.remove();

  runApp(
    const ProviderScope(
      child: KeptApp(),
    ),
  );
}

class KeptApp extends StatelessWidget {
  const KeptApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kept',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppTheme.black,
                strokeWidth: 2,
              ),
            ),
          );
        }
        if (snapshot.hasData) {
          return const MainScreen();
        }
        return const SignUpScreen();
      },
    );
  }
}