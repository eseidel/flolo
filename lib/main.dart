import 'package:flutter/material.dart';

void main() {
  runApp(const FloloApp());
}

class FloloApp extends StatelessWidget {
  const FloloApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flolo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FloloHome(),
    );
  }
}

class FloloHome extends StatefulWidget {
  const FloloHome({super.key});

  @override
  State<FloloHome> createState() => _FloloHomeState();
}

class _FloloHomeState extends State<FloloHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: CustomPaint(
        painter: FloloPainter(),
      )),
    );
  }
}

class FloloPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = Colors.green;
    canvas.drawCircle(const Offset(100, 100), 10, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
