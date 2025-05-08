import 'package:flutter/material.dart';

class ScreenSecondaryNavigationBar extends StatelessWidget {
  final String title;
  final List<Widget> actions;

  const ScreenSecondaryNavigationBar({
    super.key,
    required this.title,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, top: 16),
      width: MediaQuery.of(context).size.width * 0.80,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(100),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width * 0.33,
            right: MediaQuery.of(context).size.width * 0.33,
            child: Container(
              height: 32,
              padding: EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(title, textAlign: TextAlign.center),
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [...actions]),
        ],
      ),
    );
  }
}
