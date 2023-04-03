import 'package:flutter/material.dart';
import 'package:mob_app_dev/microphone_test_components/microphone_test.dart';

import 'microphone_test_components/recordings_library.dart';

class MicrophoneHome extends StatefulWidget {
  const MicrophoneHome({super.key});

  @override
  State<MicrophoneHome> createState() => _MicrophoneHomeState();
}

class _MicrophoneHomeState extends State<MicrophoneHome> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[
    const MicrophoneTest(),
    const RecordingsLibrary(),
  ];
  void _onMenuItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Microphone Test')),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: 'Recorder',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_music),
            label: 'Library',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onMenuItemTapped,
      ),
    );
  }
}
