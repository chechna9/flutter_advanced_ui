import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class Example3 extends StatefulWidget {
  const Example3({super.key});

  @override
  State<Example3> createState() => _Example3State();
}

const double WidthAndHeight = 100;

class _Example3State extends State<Example3> with TickerProviderStateMixin {
  late AnimationController _xController;
  late AnimationController _yController;
  late AnimationController _zController;

  late Tween<double> _animation;

  @override
  void initState() {
    super.initState();
    _xController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _yController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    _zController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0,
      end: 2 * pi,
    );
  }

  @override
  Widget build(BuildContext context) {
    _xController
      ..reset()
      ..repeat();
    _yController
      ..reset()
      ..repeat();
    _zController
      ..reset()
      ..repeat();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '3D Animations in Flutter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
            ),
            AnimatedBuilder(
                animation: Listenable.merge(
                  [
                    _xController,
                    _yController,
                    _zController,
                  ],
                ),
                builder: (context, child) {
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateX(_animation.evaluate(_xController))
                      ..rotateY(_animation.evaluate(_yController))
                      ..rotateZ(_animation.evaluate(_zController)),
                    child: Stack(
                      children: [
                        // back
                        Transform(
                          alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..translate(Vector3(0, 0, -WidthAndHeight)),
                          child: Container(
                            color: Colors.purple,
                            height: WidthAndHeight,
                            width: WidthAndHeight,
                          ),
                        ),
                        // left
                        Transform(
                          alignment: Alignment.centerRight,
                          transform: Matrix4.identity()..rotateY(-pi / 2),
                          child: Container(
                            color: Colors.red,
                            height: WidthAndHeight,
                            width: WidthAndHeight,
                          ),
                        ),
                        // right
                        Transform(
                          alignment: Alignment.centerLeft,
                          transform: Matrix4.identity()..rotateY(pi / 2),
                          child: Container(
                            color: Colors.blue,
                            height: WidthAndHeight,
                            width: WidthAndHeight,
                          ),
                        ),
                        // top
                        Transform(
                          alignment: Alignment.topCenter,
                          transform: Matrix4.identity()..rotateX(-pi / 2),
                          child: Container(
                            color: Colors.orange,
                            height: WidthAndHeight,
                            width: WidthAndHeight,
                          ),
                        ),
                        // bottom
                        Transform(
                          alignment: Alignment.bottomCenter,
                          transform: Matrix4.identity()..rotateX(pi / 2),
                          child: Container(
                            color: Colors.brown,
                            height: WidthAndHeight,
                            width: WidthAndHeight,
                          ),
                        ),
                        // front
                        Container(
                          color: Colors.green,
                          height: WidthAndHeight,
                          width: WidthAndHeight,
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _xController.dispose();
    _yController.dispose();
    _zController.dispose();
    super.dispose();
  }
}
