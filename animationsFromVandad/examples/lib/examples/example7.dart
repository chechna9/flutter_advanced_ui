import 'dart:math';

import 'package:flutter/material.dart';

class Polygone extends CustomPainter {
  final int sides;
  const Polygone({required this.sides});
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final Path path = Path();

    final center = Offset(size.width / 2, size.height / 2);
    final angle = (2 * pi) / sides;

    final angles = List.generate(sides, (index) => index * angle);

    final radius = size.width / 2;
    // initial point
    path.moveTo(
      center.dx + radius * cos(angles.first),
      center.dy + radius * sin(angles.first),
    );
    for (final angle in angles.skip(1)) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is Polygone && oldDelegate.sides != sides;
}

class Example7 extends StatefulWidget {
  const Example7({super.key});

  @override
  State<Example7> createState() => _Example7State();
}

class _Example7State extends State<Example7> with TickerProviderStateMixin {
  late AnimationController _sidesController;
  late Animation<int> _sidesAnimation;

  late AnimationController _radiusController;
  late Animation<double> _radiusAnimation;

  late AnimationController _angleController;
  late Animation<double> _angleAnimation;
  @override
  void initState() {
    _sidesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _sidesAnimation = IntTween(begin: 0, end: 10).animate(_sidesController);

    _radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _radiusAnimation = Tween<double>(begin: 20, end: 400)
        .chain(
          CurveTween(curve: Curves.bounceInOut),
        )
        .animate(_radiusController);

    _angleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _angleAnimation = Tween<double>(begin: 0, end: 2 * pi)
        .chain(
          CurveTween(curve: Curves.ease),
        )
        .animate(_angleController);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sidesController.repeat(reverse: true);
    _radiusController.repeat(reverse: true);
    _angleController.repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Custom Painter and Polygones',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: AnimatedBuilder(
            animation: Listenable.merge([
              _sidesAnimation,
              _radiusAnimation,
              _angleAnimation,
            ]),
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateZ(_angleAnimation.value)
                  ..rotateY(_angleAnimation.value)
                  ..rotateX(_angleAnimation.value),
                child: CustomPaint(
                  painter: Polygone(sides: _sidesAnimation.value),
                  child: SizedBox(
                    height: _radiusAnimation.value,
                    width: _radiusAnimation.value,
                  ),
                ),
              );
            }),
      ),
    );
  }

  @override
  void dispose() {
    _sidesController.dispose();
    _radiusController.dispose();
    _angleController.dispose();
    super.dispose();
  }
}
