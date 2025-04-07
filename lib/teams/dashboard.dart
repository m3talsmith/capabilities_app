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
        child: Column(
          children: [
            ContentContainer(
              backgroundColor: Theme.of(context).colorScheme.surface,
              child: Text('Dashboard'),
            ),
            ScreenNavigationBar(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.surface.withAlpha(50),
              showLogout: false,
              actions: [
                ScreenNavigationItem(
                  icon: Icons.add,
                  onPressed: () {},
                  title: 'Create Team',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
