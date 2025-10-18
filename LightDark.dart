import 'package:flutter/material.dart';
import 'ProfileCard1.dart';

class LightDark extends StatefulWidget {
  const LightDark({super.key});

  @override
  State<LightDark> createState() => _LightDarkState();
}

class _LightDarkState extends State<LightDark> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Example',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFF9F4FB),
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Theme Example'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                _themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: _toggleTheme, // ✅ สลับโหมด
            ),
          ],
        ),
        body: const Center(
          child: ProfileCard(
            name: 'Inthira Pookham',
            position: 'Programmer',
            email: 'pookham_i@su.ac.th',
            phoneNumber: '099-5646431',
            imageUrl: 'https://picsum.photos/id/237/200/200',
          ),
        ),
      ),
    );
  }
}
