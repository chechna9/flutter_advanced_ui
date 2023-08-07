import 'dart:math';

import 'package:animatedbuilder_transform/examples/example1.dart';
import 'package:animatedbuilder_transform/examples/example2.dart';
import 'package:animatedbuilder_transform/examples/example3.dart';
import 'package:animatedbuilder_transform/examples/example4.dart';
import 'package:animatedbuilder_transform/examples/example5.dart';
import 'package:animatedbuilder_transform/examples/example6.dart';
import 'package:animatedbuilder_transform/examples/example7.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const Example7(),
    );
  }
}
