import 'package:flutter/material.dart';
import '../ui/screen_navigation_bar.dart';
import '../ui/screen_container.dart';
import '../ui/measurements.dart';
import '../teams/teams.dart';
import '../skills/skills.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenContainer(
        navigationBar: ScreenNavigationBar(
          title: 'Dashboard',
          activeItem: ScreenActiveItem.dashboard,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - safeArea,
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width ~/ 200,
              ),
              children: [
                InkWell(
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => TeamsView()),
                      ),
                  child: Card(
                    child: Center(
                      child: Text(
                        'Teams',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap:
                      () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SkillsView()),
                      ),
                  child: Card(
                    child: Center(
                      child: Text(
                        'Skills',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
