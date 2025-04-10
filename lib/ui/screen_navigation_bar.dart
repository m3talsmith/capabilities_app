import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth.dart';
import '../auth/login.dart';
import '../teams/teams.dart';

class ScreenNavigationBar extends ConsumerWidget {
  final List<ScreenNavigationItem>? navigationItems;
  final String? title;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? titleColor;
  final bool? showLogout;
  final bool? showBackButton;
  final double? width;

  const ScreenNavigationBar({
    super.key,
    this.navigationItems,
    this.title,
    this.actions,
    this.backgroundColor,
    this.titleColor,
    this.showLogout = true,
    this.width,
    this.showBackButton = true,
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
                        icon: Icons.workspaces_rounded,
                        onPressed:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TeamsView(),
                              ),
                            ),
                      ),
                      ScreenNavigationItem(
                        icon: Icons.person_rounded,
                        onPressed: () {},
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
  final Color? iconColor;
  final Color? textColor;
  final bool? isActive;
  final EdgeInsets? padding;

  const ScreenNavigationItem({
    super.key,
    this.title,
    required this.icon,
    this.onPressed,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.iconColor,
    this.textColor,
    this.isActive,
    this.padding,
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
          title != null
              ? TextButton.icon(
                style: TextButton.styleFrom(minimumSize: Size(50, 50)),
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).colorScheme.onSurface,
                ),
                label: Text(
                  title ?? '',
                  style: TextStyle(
                    color: textColor ?? Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              )
              : IconButton(
                onPressed: onPressed,
                icon: Icon(
                  icon,
                  color: iconColor ?? Theme.of(context).colorScheme.onSurface,
                ),
              ),
    );
  }
}
