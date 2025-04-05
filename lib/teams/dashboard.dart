import 'package:capabilities_app/ui/screen_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: ScreenContainer(
        child: Column(
          children: [
            Text('Dashboard'),
            Text('Dashboard'),
            Text('Dashboard'),
            Text('Dashboard'),
            Text('Dashboard'),
          ],
        ),
      ),
    );
  }
}
