import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/team.dart';
import '../ui/screen_container.dart';
import '../ui/screen_navigation_bar.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenContainer(
        navigationBar: ScreenNavigationBar(
          title: widget.team.teamName ?? 'Unknown',
        ),
        child: Column(
          children: [Text(widget.team.teamDescription ?? 'No description')],
        ),
      ),
    );
  }
}
