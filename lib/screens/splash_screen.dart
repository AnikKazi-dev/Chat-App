import 'package:flutter/material.dart';

class SplashSCreen extends StatelessWidget {
  const SplashSCreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Text(
          "Loading.......",
        ),
      ),
    );
  }
}
