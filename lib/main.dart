import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:smart_task_manager/features/home/presentation/screens/home_screen.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/auth/presentation/providers/auth_controller.dart';
import 'core/theme/theme_provider.dart';
import 'features/profile/presentation/providers/profile_controller.dart';
import 'core/theme/theme_provider.dart';
import 'features/tasks/presentation/screens/task_list_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {


    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
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
            body: Center(child: CircularProgressIndicator()),
          );
        }

        
        if (!snapshot.hasData) {
          return const LoginScreen();
        }

      
        final user = snapshot.data!;
        return HomeScreen(userId: user.uid);
      },
    );
  }
}