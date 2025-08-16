import 'package:flutter/material.dart';

class AnimatedAuthCard extends StatelessWidget {
  final Widget child;
  final double height;
  const AnimatedAuthCard({super.key, required this.child, this.height = 380});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.all(16),
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(blurRadius: 20, color: Colors.black26)],
        ),
        child: child,
      ),
    );
  }
}
