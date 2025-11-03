import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  final bool small;

  const AnimatedLogo({super.key, this.small = false});

  @override
  Widget build(BuildContext context) {
    final double size = small ? 30 : 40;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(left: 6.0),
      width: size,
      height: size,
      child: Image.asset(
        'assets/logo.png', // Make sure logo.png is added in pubspec.yaml
        fit: BoxFit.contain,
      ),
    );
  }
}
