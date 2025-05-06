import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth.dart';
import '../auth/login.dart';
import '../teams/teams.dart';
import '../skills/skills.dart';
import '../dashboard/dashboard.dart';

enum ScreenActiveItem { teams, skills, dashboard }

class ScreenNavigationBar extends ConsumerWidget {
  final List<ScreenNavigationItem>? navigationItems;
  final String? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? activeColor;
  final Color? titleColor;
  final bool? showLogout;
  final bool? showBackButton;
  final double? width;
  final ScreenActiveItem? activeItem;

  const ScreenNavigationBar({
    super.key,
    this.navigationItems,
    this.title,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.activeBackgroundColor,
    this.activeColor,
    this.showLogout = true,
    this.width,
    this.showBackButton = true,
    this.activeItem = ScreenActiveItem.dashboard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canPop = Navigator.canPop(context);
    final auth = ref.watch(authProvider);
    final width =
        this.width ??
        (MediaQuery.of(context).size.width > 1024
            ? MediaQuery.of(context).size.width * 0.66
            : MediaQuery.of(context).size.width);

    return Container(
      width: width,
      height: 40,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
            backgroundColor ??
            Theme.of(context).colorScheme.surface.withAlpha(200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              title ?? '',
              style: TextStyle(
                color: titleColor ?? Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (canPop && showBackButton == true)
                      ScreenNavigationItem(
                        icon: Icons.arrow_back,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ...[
                      ScreenNavigationItem(
                        icon: Icons.dashboard_rounded,
                        title: 'Dashboard',
                        isActive: activeItem == ScreenActiveItem.dashboard,
                        activeBackgroundColor: activeBackgroundColor,
                        activeColor: activeColor,
                        onPressed:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => DashboardView(),
                              ),
                            ),
                      ),
                      ScreenNavigationItem(
                        icon: Icons.diversity_2_rounded,
                        title: 'Teams',
                        isActive: activeItem == ScreenActiveItem.teams,
                        activeBackgroundColor: activeBackgroundColor,
                        activeColor: activeColor,
                        onPressed:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TeamsView(),
                              ),
                            ),
                      ),
                      ScreenNavigationItem(
                        icon: Icons.rocket_launch_rounded,
                        title: 'Skills',
                        isActive: activeItem == ScreenActiveItem.skills,
                        activeBackgroundColor: activeBackgroundColor,
                        activeColor: activeColor,
                        onPressed:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => SkillsView(),
                              ),
                            ),
                      ),
                    ],
                    ...navigationItems ?? [],
                  ],
                ),
              ),

              Expanded(child: SizedBox.shrink()),
              ...(actions ?? []),
              if (auth != null && showLogout == true)
                ScreenNavigationItem(
                  icon: Icons.logout,
                  onPressed: () {
                    signOut(ref);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class ScreenNavigationItem extends StatelessWidget {
  final String? title;
  final IconData icon;
  final Function()? onPressed;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final Color? activeColor;
  final Color? iconColor;
  final Color? textColor;
  final bool? isActive;
  final EdgeInsets? padding;
  final bool? showTitle;

  const ScreenNavigationItem({
    super.key,
    this.title,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.activeColor,
    this.iconColor,
    this.textColor,
    this.isActive,
    this.padding,
    this.showTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color:
            isActive ?? false
                ? activeBackgroundColor ?? Theme.of(context).colorScheme.surface
                : backgroundColor ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child:
          title != null && showTitle == true
              ? TextButton.icon(
                style: TextButton.styleFrom(
                  minimumSize: Size(50, 50),
                  backgroundColor:
                      isActive ?? false
                          ? activeBackgroundColor ??
                              Theme.of(context).colorScheme.surface
                          : backgroundColor ??
                              Theme.of(context).colorScheme.surface,
                ),
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  color:
                      isActive ?? false
                          ? activeColor ??
                              Theme.of(context).colorScheme.onPrimary
                          : iconColor ??
                              Theme.of(context).colorScheme.onSurface,
                ),
                label: Text(
                  title ?? '',
                  style: TextStyle(
                    color:
                        isActive ?? false
                            ? activeColor ??
                                Theme.of(context).colorScheme.onPrimary
                            : textColor ??
                                Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )
              : IconButton(
                onPressed: onPressed,
                style: IconButton.styleFrom(
                  backgroundColor:
                      isActive ?? false
                          ? activeBackgroundColor ??
                              Theme.of(context).colorScheme.surface
                          : backgroundColor ??
                              Theme.of(context).colorScheme.surface,
                ),
                icon: Icon(
                  icon,
                  color:
                      isActive ?? false
                          ? activeColor ??
                              Theme.of(context).colorScheme.onPrimary
                          : iconColor ??
                              Theme.of(context).colorScheme.onSurface,
                ),
              ),
    );
  }
}
