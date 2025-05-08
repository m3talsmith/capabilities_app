import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/team.dart';
import '../models/user.dart';
import '../ui/screen_container.dart';
import '../ui/screen_navigation_bar.dart';
import '../ui/screen_secondary_navigation_bar.dart';
import '../providers/users.dart';

class TeamView extends ConsumerStatefulWidget {
  final Team team;

  const TeamView({super.key, required this.team});

  @override
  ConsumerState<TeamView> createState() => _TeamViewState();
}

class _TeamViewState extends ConsumerState<TeamView> {
  @override
  void initState() {
    super.initState();
    if (widget.team.id != null) {
      ref.read(usersProvider.notifier).getUsers(widget.team.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = ref.watch(usersProvider);
    return Scaffold(
      body: ScreenContainer(
        navigationBar: ScreenNavigationBar(
          title: widget.team.teamName ?? 'Unknown',
        ),
        child: Column(
          children: [
            users.when(
              data:
                  (List<User> data) => SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 2,
                    child: Column(
                      children: [
                        ScreenSecondaryNavigationBar(
                          title: "Team Members",
                          actions: [
                            FilledButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.add),
                              label: Text("Add Member"),
                            ),
                          ],
                        ),
                        data.isEmpty
                            ? Center(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text("No users found"),
                              ),
                            )
                            : GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width ~/
                                        100,
                                  ),
                              itemBuilder:
                                  (context, index) => Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.surface,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '${data[index].lastName}, ${data[index].firstName}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                            ),
                      ],
                    ),
                  ),
              error:
                  (error, stack) => Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Error loading users"),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
