import '../ui/screen_container.dart';
import '../ui/screen_navigation_bar.dart';
import '../ui/content_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ScreenContainer(
        navigationBar: ScreenNavigationBar(title: 'Dashboard'),
        child: ContentContainer(
          backgroundColor: Theme.of(context).colorScheme.surface,
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
      ),
    );
  }
}
