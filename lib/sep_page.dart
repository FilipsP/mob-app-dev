import 'package:flutter/material.dart';

class SepPage extends StatelessWidget {
  const SepPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Separate Page')),
      body: const Center(
        child: Text(
          'This is a separate page',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
