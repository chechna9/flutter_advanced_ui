import 'package:flutter/material.dart';

const double defaultWidth = 100.0;

class Example5 extends StatefulWidget {
  const Example5({super.key});

  @override
  State<Example5> createState() => _Example5State();
}

class _Example5State extends State<Example5> {
  bool _isZoomed = false;
  String _title = "Zoom In";
  double _width = 200;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animated Container',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              color: Colors.blue,
              width: _width,
              duration: const Duration(milliseconds: 370),
              curve: Curves.easeIn,
              child: FlutterLogo(
                size: _width,
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isZoomed = !_isZoomed;
                  _title = _isZoomed ? "Zoom Out" : "Zoom In";
                  _width = _isZoomed
                      ? MediaQuery.of(context).size.width
                      : defaultWidth;
                });
              },
              child: Text(_title),
            ),
          ],
        ),
      ),
    );
  }
}
