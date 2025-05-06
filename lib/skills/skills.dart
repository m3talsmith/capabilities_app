import 'package:capabilities_app/ui/screen_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../providers/skills.dart';
import '../ui/screen_navigation_bar.dart';
import '../ui/measurements.dart';
import 'form.dart';
import '../models/skill.dart';

class SkillsView extends ConsumerStatefulWidget {
  @override
  ConsumerState<SkillsView> createState() => _SkillsViewState();
}

class _SkillsViewState extends ConsumerState<SkillsView> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getSkills();
  }

  Future<void> getSkills() async {
    setState(() {
      isLoading = true;
    });

    await ref.read(skillsProvider.notifier).getSkills();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> createSkill(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(child: SkillForm()),
    );

    if (result == false) {
      return;
    }

    await getSkills();
  }

  Future<void> editSkill(BuildContext context, Skill skill) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(child: SkillForm(skill: skill)),
    );

    if (result == false) {
      return;
    }

    await getSkills();
  }

  Future<void> deleteSkill(BuildContext context, Skill skill) async {
    final result = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text('Delete Skill'),
            content: Text('Are you sure you want to delete this skill?'),
            actions: [
              TextButton.icon(
                onPressed: () => Navigator.of(context).pop(false),
                icon: Icon(Icons.cancel),
                label: Text('Cancel'),
              ),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(true),
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).colorScheme.surface,
                ),
                label: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
              ),
            ],
          ),
    );

    if (result == false) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    await ref.read(deleteSkillProvider.notifier).deleteSkill(skill);

    setState(() {
      isLoading = false;
    });

    final deletedSkill = ref.read(deleteSkillProvider);

    deletedSkill.when(
      data: (data) async {
        setState(() {
          isLoading = true;
        });

        final messenger = ScaffoldMessenger.of(context);

        await getSkills();

        setState(() {
          isLoading = false;
        });

        messenger.showSnackBar(
          SnackBar(content: Text('Skill deleted successfully')),
        );
      },
      error: (error, stack) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final skills = ref.watch(skillsProvider);

    final activeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: ScreenContainer(
        navigationBar: ScreenNavigationBar(
          title: 'Skills',
          activeItem: ScreenActiveItem.skills,
          activeColor: activeColor,
        ),
        child:
            isLoading
                ? SizedBox(
                  height: MediaQuery.of(context).size.height - safeArea,
                  width: MediaQuery.of(context).size.width,
                  child: Center(child: CircularProgressIndicator()),
                )
                : skills.when(
                  data:
                      (skills) =>
                          skills.isEmpty
                              ? Center(
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height -
                                      safeArea,
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                    child: FilledButton.icon(
                                      onPressed: () => createSkill(context),
                                      label: Text(
                                        'Create Skill',
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                        ),
                                      ),
                                      icon: Icon(
                                        Icons.add,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              : SizedBox(
                                height:
                                    MediaQuery.of(context).size.height -
                                    safeArea,
                                width: MediaQuery.of(context).size.width,
                                child: GridView(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount:
                                            MediaQuery.of(context).size.width ~/
                                            200,
                                      ),
                                  children:
                                      skills
                                          .map(
                                            (skill) => SkillCard(
                                              skill: skill,
                                              onEdit:
                                                  () async => await editSkill(
                                                    context,
                                                    skill,
                                                  ),
                                              onDelete:
                                                  () async => await deleteSkill(
                                                    context,
                                                    skill,
                                                  ),
                                              isLoading: isLoading,
                                            ),
                                          )
                                          .toList(),
                                ),
                              ),
                  error: (error, stack) => Text(error.toString()),
                  loading: () {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height - safeArea,
                      width: MediaQuery.of(context).size.width,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => createSkill(context),
        label: Text('Create Skill'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class SkillCard extends StatelessWidget {
  final Skill skill;
  final Function()? onEdit;
  final Function()? onDelete;
  final bool isLoading;

  const SkillCard({
    super.key,
    required this.skill,
    this.onEdit,
    this.onDelete,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          skill.skillName ?? '',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Text('Level: ${skill.skillLevel}'),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: PopupMenuButton(
                      itemBuilder:
                          (context) => [
                            PopupMenuItem(
                              onTap: onEdit,
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              onTap: onDelete,
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text(
                                    'Delete',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                    ),
                  ),
                ],
              ),
    );
  }
}
