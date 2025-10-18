import 'package:flutter/material.dart';

void main() {
  runApp(const TrafficLightApp());
}

class TrafficLightApp extends StatelessWidget {
  const TrafficLightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Traffic Light Animation',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
        ),
      ),
      home: const TrafficLightPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TrafficLightPage extends StatefulWidget {
  const TrafficLightPage({super.key});

  @override
  State<TrafficLightPage> createState() => _TrafficLightPageState();
}

class _TrafficLightPageState extends State<TrafficLightPage> {
  int _lightIndex = 0;

  void _changeLight() {
    setState(() {
      _lightIndex = (_lightIndex + 1) % 3;
    });
  }

  double _getOpacity(int index) {
    return _lightIndex == index ? 1.0 : 0.3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Traffic Light Animation"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ไฟแดง
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _getOpacity(0),
              child: _buildLight(Colors.red),
            ),
            const SizedBox(height: 16),
            // ไฟเหลือง
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _getOpacity(1),
              child: _buildLight(Colors.yellow),
            ),
            const SizedBox(height: 16),
            // ไฟเขียว
            AnimatedOpacity(
              duration: const Duration(milliseconds: 500),
              opacity: _getOpacity(2),
              child: _buildLight(Colors.green),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _changeLight,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "เปลี่ยนไฟ",
                style: TextStyle(fontSize: 18, color: Colors.purple),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLight(Color color) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }
}
