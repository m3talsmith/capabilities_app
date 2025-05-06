import 'package:capabilities_app/providers/skills.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/skill.dart';

class SkillForm extends ConsumerStatefulWidget {
  final Skill? skill;

  const SkillForm({super.key, this.skill});

  @override
  ConsumerState<SkillForm> createState() => _SkillFormState();
}

class _SkillFormState extends ConsumerState<SkillForm> {
  final skillNameController = TextEditingController();
  int skillLevelController = 1;
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    skillNameController.text = widget.skill?.skillName ?? '';
    skillLevelController = widget.skill?.skillLevel ?? 1;
  }

  Future<void> save(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    if (widget.skill?.id != null) {
      await ref
          .read(updateSkillProvider.notifier)
          .updateSkill(
            Skill(
              id: widget.skill?.id,
              skillName: skillNameController.text,
              skillLevel: skillLevelController,
            ),
          );

      final skill = ref.read(updateSkillProvider);
      skill.when(
        data: (data) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Skill updated succesfully')));
          Navigator.of(context).pop();
        },
        error: (error, stacktrace) {
          setState(() {
            errorMessage = error.toString();
          });
        },
        loading: () {},
      );
    } else {
      await ref
          .read(createSkillProvider.notifier)
          .createSkill(
            Skill(
              skillName: skillNameController.text,
              skillLevel: skillLevelController,
            ),
          );

      final skill = ref.read(createSkillProvider);
      skill.when(
        data: (data) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Skill created succesfully')));
          Navigator.of(context).pop();
        },
        error: (error, stacktrace) {
          setState(() {
            errorMessage = error.toString();
          });
        },
        loading: () {},
      );
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            widget.skill == null ? 'AddSkill' : 'Edit Skill',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: skillNameController,
                  decoration: InputDecoration(labelText: 'Name'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    'Level',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                Slider(
                  value: skillLevelController.toDouble(),
                  onChanged: (value) {
                    setState(() {
                      skillLevelController = value.toInt();
                    });
                  },
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: skillLevelController.toString(),
                ),
                Divider(height: 1),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(false),
                  label: Text('Cancel'),
                  icon: Icon(Icons.cancel),
                ),
                FilledButton.icon(
                  onPressed: () => save(context),
                  icon: Icon(Icons.save),
                  label: Text('Save'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
