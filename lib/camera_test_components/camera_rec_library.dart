import 'package:flutter/material.dart';

class CameraRecLibrary extends StatefulWidget {
  const CameraRecLibrary({super.key});

  @override
  State<CameraRecLibrary> createState() => _CameraRecLibraryState();
}

class _CameraRecLibraryState extends State<CameraRecLibrary> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Library'),
      ),
    );
  }
}
