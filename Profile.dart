import 'package:flutter/material.dart';
import 'ProfileCard.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 134, 119, 119),
      body: const Center(
        child: ProfileCard(
          name: 'Inthira Pookham',
          position: 'Programmer',
          email: 'pookham_i@su.ac.th',
          phoneNumber: '099-5646431',
          imageUrl: 'https://picsum.photos/200',
        ),
      ),
    );
  }
}
