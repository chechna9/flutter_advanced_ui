import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Swipeable Card Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Swipeable Card Demo'),
      ),
      backgroundColor: Colors.amber,
      body: const SlidingBlockExample(),
    );
  }
}

class SlidingBlockExample extends StatefulWidget {
  const SlidingBlockExample({super.key});

  @override
  State<SlidingBlockExample> createState() => _SlidingBlockExampleState();
}

class _SlidingBlockExampleState extends State<SlidingBlockExample>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  double drag = 0;
  double position = 0;
  double velocity = 0;
  @override
  void initState() {
    super.initState();
    // unbound can customize the state not only from 0 to 1
    animationController = AnimationController.unbounded(vsync: this);
  }

  void _nudgeBlock() {
    FrictionSimulation nonMovingSim =
        FrictionSimulation(drag, position, velocity);
    animationController.animateWith(nonMovingSim);
  }

  void _resetBlock() {
    FrictionSimulation nonMovingSim = FrictionSimulation(0, 0, 0);
    animationController.animateWith(nonMovingSim);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'drag',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                        min: 0,
                        max: 1,
                        value: drag,
                        onChanged: (change) {
                          setState(
                            () {
                              drag = change;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Position',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                        min: -100,
                        max: 100,
                        value: position,
                        onChanged: (change) {
                          setState(
                            () {
                              position = change;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Velocity',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Slider(
                        min: 0.0,
                        max: 100,
                        value: velocity,
                        onChanged: (change) {
                          setState(
                            () {
                              velocity = change;
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: screenSize.height / 3,
          child: Container(
            color: Colors.blue,
          ),
        ),
        AnimatedBuilder(
            animation: animationController,
            builder: (context, builder) {
              return Positioned(
                height: 50,
                width: 50,
                bottom: screenSize.height / 3,
                left: screenSize.width / 4 - 25 + animationController.value,
                child: Container(
                  color: Colors.red,
                ),
              );
            }),
        Positioned(
          bottom: screenSize.height / 6,
          child: Row(
            children: [
              ElevatedButton(
                onPressed: _nudgeBlock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 10,
                ),
                child: const Text("Nudge"),
              ),
              const SizedBox(
                width: 20,
              ),
              ElevatedButton(
                onPressed: _resetBlock,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  elevation: 10,
                ),
                child: const Text("Reset"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
