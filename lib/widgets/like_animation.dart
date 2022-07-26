import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;
  final bool isAnimaing;
  final Duration duration;
  final VoidCallback? onEnd;
  bool smallLike;

  LikeAnimation(
      {Key? key,
      required this.child,
      required this.isAnimaing,
      this.duration = const Duration(microseconds: 150),
      this.onEnd,
      this.smallLike = false})
      : super(key: key);

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scale;
  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(microseconds: widget.duration.inMicroseconds ~/ 2));
    super.initState();
    scale = Tween<double>(begin: 1, end: 1.2).animate(controller);
  }

  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnimaing != oldWidget.isAnimaing) {
      startAnimation();
    }
  }

  startAnimation() async {
    if (widget.isAnimaing || widget.smallLike) {
      await controller.forward();
      await controller.reverse();
      await Future.delayed(const Duration(microseconds: 200));
      if (widget.onEnd != null) {
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child,
    );
  }
}
