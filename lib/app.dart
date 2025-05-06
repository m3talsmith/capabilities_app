import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth/login.dart';
import 'dashboard/dashboard.dart';
import 'providers/auth.dart';
import 'app_theme_data.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.theme,
      home: auth?.isValid == true ? const DashboardView() : const Login(),
    );
  }
}
