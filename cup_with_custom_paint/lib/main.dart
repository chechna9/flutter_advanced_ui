import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: GlassOfLiquidDemo(),
    );
  }
}

class GlassOfLiquidDemo extends StatefulWidget {
  const GlassOfLiquidDemo({super.key});

  @override
  State<GlassOfLiquidDemo> createState() => _GlassOfLiquidDemoState();
}

class _GlassOfLiquidDemoState extends State<GlassOfLiquidDemo> {
  double _skew = 1;
  double _liquidLevel = .5;
  double _ratio = .5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 120,
                height: 180,
                child: CustomPaint(
                  painter: GlassOfLiquid(
                      skew: _skew, ratio: _ratio, liquidLevel: _liquidLevel),
                ),
              ),
            ),
          ),
          const Text('Skew'),
          Slider(
            value: _skew,
            onChanged: (value) {
              setState(() {
                _skew = value;
              });
            },
          ),
          const Text('Ratio'),
          Slider(
            value: _ratio,
            onChanged: (value) {
              setState(() {
                _ratio = value;
              });
            },
          ),
          const Text('Milk Level'),
          Slider(
            value: _liquidLevel,
            onChanged: (value) {
              setState(() {
                _liquidLevel = value;
              });
            },
          ),
        ],
      ),
    );
  }
}

class GlassOfLiquid extends CustomPainter {
  final double skew;
  final double ratio;
  final double liquidLevel;
  GlassOfLiquid(
      {required this.liquidLevel, required this.ratio, required this.skew});
  @override
  void paint(Canvas canvas, Size size) {
    // paints
    Paint glass = Paint()
      ..color = Colors.white.withAlpha(150)
      ..style = PaintingStyle.fill;

    Paint black = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Paint milkTopPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.fill;

    Paint milkColorPaint = Paint()
      ..color = Colors.white54
      ..style = PaintingStyle.fill;

    // / rects

    Rect top = Rect.fromLTRB(
      0,
      0,
      size.width,
      size.width * skew,
    );

    Rect bottom = Rect.fromCenter(
      center: Offset(size.width * 0.5, size.height - size.width * skew),
      width: size.width * ratio,
      height: size.width * skew * ratio,
    );

    Rect? liquidTop = Rect.lerp(bottom, top, liquidLevel);
    // pahts
    Path cupPath = Path()
      ..moveTo(top.left, top.top + top.height * .5)
      ..arcTo(top, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * 0.5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(top.left, top.top + top.height * 0.5);

    Path liquidPath = Path()
      ..moveTo(liquidTop!.left, liquidTop.top + top.height * .5)
      ..arcTo(liquidTop, pi, pi, true)
      ..lineTo(bottom.right, bottom.top + bottom.height * 0.5)
      ..arcTo(bottom, 0, pi, true)
      ..lineTo(liquidTop.left, liquidTop.top + liquidTop.height * 0.5);
// drawing
    canvas.drawPath(cupPath, glass);
    canvas.drawPath(liquidPath, milkColorPaint);
    canvas.drawOval(liquidTop, milkTopPaint);
    canvas.drawPath(cupPath, black);
    canvas.drawOval(top, black);
  }

  @override
  bool shouldRepaint(GlassOfLiquid oldDelegate) {
    return oldDelegate.liquidLevel != liquidLevel ||
        oldDelegate.ratio != ratio ||
        oldDelegate.skew != skew;
  }
}
