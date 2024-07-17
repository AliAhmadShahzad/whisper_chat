import 'package:flutter/material.dart';

class EmojiAnimation extends StatefulWidget {
  final String emoji;

  const EmojiAnimation({Key? key, required this.emoji}) : super(key: key);

  @override
  _EmojiAnimationState createState() => _EmojiAnimationState();
}

class _EmojiAnimationState extends State<EmojiAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: List.generate(40, (index) {
          double startPosition = (index * 0.025);
          double size = 20 + (index % 4 * 10).toDouble(); // Different sizes
          return AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Positioned(
                bottom: 0,
                left: MediaQuery.of(context).size.width * startPosition,
                child: Transform.translate(
                  offset: Offset(0, -MediaQuery.of(context).size.height * _animation.value),
                  child: Text(
                    widget.emoji,
                    style: TextStyle(fontSize: size),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
