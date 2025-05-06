import 'package:capabilities_app/ui/content_card.dart';
import '../ui/screen_container.dart';
import '../ui/screen_navigation_bar.dart';
import '../ui/content_container.dart';
import '../ui/measurements.dart';
import '../models/team.dart';
import '../providers/teams.dart';
import 'form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'team.dart';

class TeamsView extends ConsumerStatefulWidget {
  const TeamsView({super.key});

  @override
  ConsumerState<TeamsView> createState() => _TeamsViewState();
}

class _TeamsViewState extends ConsumerState<TeamsView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getTeams();
  }

  getTeams() async {
    setState(() => isLoading = true);
    await ref.read(teamsProvider.notifier).getTeams();
    setState(() => isLoading = false);
  }

  createTeam(context) async {
    await showAdaptiveDialog(
      context: context,
      builder: (context) => Dialog(child: TeamForm(team: Team())),
    );
  }

  editTeam(context, Team team) async {
    Navigator.of(context).pop();
    await showDialog(
      context: context,
      builder: (context) => Dialog(child: TeamForm(team: team)),
    );
    setState(() => isLoading = true);
    await ref.read(teamsProvider.notifier).getTeams();
    setState(() => isLoading = false);
  }

  deleteTeam(context, Team team) async {
    Navigator.of(context).pop();
    final response = await showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Team'),
            content: Text(
              'Are you sure that you want to delete the team: ${team.teamName}?',
            ),
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(false),
                icon: Icon(Icons.cancel_rounded),
                label: Text('Cancel'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: Icon(
                  Icons.delete_rounded,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
                label: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
            ],
          ),
    );
    if (response) {
      setState(() => isLoading = true);
      await ref.read(deleteTeamProvider.notifier).deleteTeam(team: team);
      final teamState = ref.read(teamsProvider);
      if (teamState.hasError) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(teamState.error.toString())));
        return;
      }

      await getTeams();
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Team deleted successfully')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final teams = ref.watch(teamsProvider);

    return Scaffold(
      body: ScreenContainer(
        navigationBar: ScreenNavigationBar(
          title: 'Teams',
          activeItem: ScreenActiveItem.teams,
          activeColor: Theme.of(context).colorScheme.primary,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - safeArea,
          child:
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : teams.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return Center(
                          child: FilledButton.icon(
                            onPressed: () => createTeam(context),
                            icon: Icon(
                              Icons.add_rounded,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onInverseSurface,
                            ),
                            label: Text(
                              'Create Team',
                              style: TextStyle(
                                color:
                                    Theme.of(
                                      context,
                                    ).colorScheme.onInverseSurface,
                              ),
                            ),
                          ),
                        );
                      }

                      return GridView(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              MediaQuery.of(context).size.width ~/ 200,
                        ),
                        children:
                            data
                                .map(
                                  (team) => ContentCard(
                                    title: team.teamName ?? 'Unknown',
                                    subtitle: team.teamDescription,
                                    onTap:
                                        () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder:
                                                (context) =>
                                                    TeamView(team: team),
                                          ),
                                        ),
                                    actions: [
                                      ContentCardAction(
                                        label: 'Edit',
                                        icon: Icons.edit_rounded,
                                        onTap: () => editTeam(context, team),
                                      ),
                                      ContentCardAction(
                                        label: 'Delete',
                                        icon: Icons.delete_rounded,
                                        color: Colors.red,
                                        onTap: () => deleteTeam(context, team),
                                      ),
                                    ],
                                  ),
                                )
                                .toList(),
                      );
                    },
                    error:
                        (error, stackTrace) => SizedBox(
                          height: double.infinity,
                          child: Center(
                            child: ContentContainer(
                              child: Text(error.toString()),
                            ),
                          ),
                        ),
                    loading: () => Center(child: CircularProgressIndicator()),
                  ),
        ),
      ),
      floatingActionButton:
          isLoading
              ? null
              : FloatingActionButton.extended(
                onPressed: () => createTeam(context),
                label: Text('Create Team'),
                icon: Icon(Icons.add_rounded),
              ),
    );
  }
}
