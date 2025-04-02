import 'package:flutter/material.dart';

class ScreenContainer extends StatelessWidget {
  final Widget? child;

  const ScreenContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
