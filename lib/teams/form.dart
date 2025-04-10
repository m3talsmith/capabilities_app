import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../models/team.dart';
import '../providers/teams.dart';

class TeamForm extends ConsumerStatefulWidget {
  final Team team;

  const TeamForm({super.key, required this.team});

  @override
  ConsumerState<TeamForm> createState() => _TeamFormState();
}

class _TeamFormState extends ConsumerState<TeamForm> {
  final teamNameController = TextEditingController();
  final teamDescriptionController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  save(context) async {
    if (teamNameController.text.isEmpty) {
      setState(() => errorMessage = 'Team name is required');
      return;
    }

    setState(() => isLoading = true);

    if (widget.team.id == null) {
      await ref
          .read(createTeamProvider.notifier)
          .createTeam(
            teamName: teamNameController.text,
            teamDescription: teamDescriptionController.text,
          );

      final result = ref.read(createTeamProvider);
      result.when(
        data: (data) async {
          await ref.read(teamsProvider.notifier).getTeams();
          setState(() => isLoading = false);
          Navigator.of(context).pop();
        },
        error: (error, stack) {
          setState(() => errorMessage = error.toString());
        },
        loading: () {
          setState(() => isLoading = true);
        },
      );
      return;
    }

    await ref
        .read(editTeamProvider.notifier)
        .editTeam(
          team: Team(
            id: widget.team.id,
            teamName: teamNameController.text,
            teamDescription: teamDescriptionController.text,
          ),
        );
    final result = ref.read(editTeamProvider);
    result.when(
      data: (data) async {
        await ref.read(teamsProvider.notifier).getTeams();
        setState(() => isLoading = false);
        Navigator.of(context).pop();
      },
      error: (error, stack) {
        setState(() {
          errorMessage = error.toString();
          isLoading = false;
        });
      },
      loading: () {
        setState(() => isLoading = true);
      },
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.team.id != null) {
      teamNameController.text = widget.team.teamName ?? '';
      teamDescriptionController.text = widget.team.teamDescription ?? '';
    }
  }

  @override
  void dispose() {
    teamNameController.dispose();
    teamDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Text(
                    'Team Form',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: teamNameController,
                          decoration: InputDecoration(
                            labelText: 'Team Name',
                            prefixIcon: Icon(Icons.text_fields),
                          ),
                          onSubmitted: (value) => save(context),
                        ),
                        TextField(
                          controller: teamDescriptionController,
                          decoration: InputDecoration(
                            labelText: 'Team Description',
                            prefixIcon: Icon(Icons.description),
                          ),
                          maxLines: 5,
                          onSubmitted: (value) => save(context),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 16),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Cancel'),
                              ),
                              FilledButton.icon(
                                onPressed: () => save(context),
                                icon: Icon(
                                  Icons.add,
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.onInverseSurface,
                                ),
                                label: Text(
                                  widget.team.id == null
                                      ? 'Create Team'
                                      : 'Update Team',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelLarge?.copyWith(
                                    color:
                                        Theme.of(
                                          context,
                                        ).colorScheme.onInverseSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (errorMessage.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(top: 16),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          errorMessage,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}
