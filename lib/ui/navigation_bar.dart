import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  final List<NavigationItem>? navigationItems;
  final String? title;

  const NavigationBar({super.key, this.navigationItems, this.title});

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.canPop(context);

    return Container(
      child: Row(
        children: [
          if (canPop)
            NavigationItem(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
          Text(title ?? ''),
        ],
      ),
    );
  }
}

class NavigationItem extends StatelessWidget {
  final String? title;
  final IconData icon;
  final Function()? onPressed;

  const NavigationItem({
    super.key,
    this.title,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: IconButton(onPressed: onPressed, icon: Icon(icon)),
    );
  }
}
