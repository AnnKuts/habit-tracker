import 'package:flutter/material.dart';

class AnimatedStreakFire extends StatefulWidget {
  const AnimatedStreakFire({super.key});

  @override
  State<AnimatedStreakFire> createState() => _AnimatedStreakFireState();
}

class _AnimatedStreakFireState extends State<AnimatedStreakFire>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(begin: 0.20, end: 0.45).animate(_controller);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final scheme = Theme.of(context).colorScheme;

    _colorAnimation = ColorTween(
      begin: scheme.primary,
      end: scheme.secondary,
    ).animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _colorAnimation.value!.withValues(
                    alpha: _glowAnimation.value,
                  ),
                  blurRadius: 70,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Icon(
                Icons.local_fire_department_rounded,
                size: 180,
                color: _colorAnimation.value,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
