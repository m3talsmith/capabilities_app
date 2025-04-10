import 'package:flutter/material.dart';

class ContentCardAction {
  final String label;
  final IconData? icon;
  final Color? color;
  final VoidCallback? onTap;

  ContentCardAction({required this.label, this.icon, this.color, this.onTap});
}

class ContentCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final List<ContentCardAction> actions;

  const ContentCard({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.labelLarge),
                    Text(
                      subtitle ?? '',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: PopupMenuButton(
              itemBuilder:
                  (context) =>
                      actions
                          .map(
                            (action) => PopupMenuItem(
                              child: InkWell(
                                onTap: action.onTap,
                                child: Row(
                                  children: [
                                    if (action.icon != null) ...[
                                      Icon(action.icon, color: action.color),
                                      SizedBox(width: 8),
                                    ],
                                    Text(
                                      action.label,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(color: action.color),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
