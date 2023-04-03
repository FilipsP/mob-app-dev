import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';

class Recording {
  final String name;
  final String url;
  Recording(this.name, this.url);
}

class RecordingsLibrary extends StatefulWidget {
  const RecordingsLibrary({super.key});

  @override
  State<RecordingsLibrary> createState() => _RecordingsLibraryState();
}

class _RecordingsLibraryState extends State<RecordingsLibrary> {
  final List<Recording> _recordings = [];
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isPaused = false;
  int _currentRecording = 0;

  @override
  void initState() {
    _getRecordings();
    super.initState();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playRecording(String url) async {
    await _audioPlayer.play(DeviceFileSource(url));
    setState(() {
      _isPlaying = true;
    });
  }

  void _stopRecording() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

  void _pauseRecording() async {
    await _audioPlayer.pause();
    setState(() {
      _isPaused = true;
    });
  }

  void _resumeRecording() async {
    await _audioPlayer.resume();
    setState(() {
      _isPaused = false;
    });
  }

  void _deleteRecording(String url) async {
    bool? isAccept = await _promptForDeleteFile();
    if (isAccept == null || !isAccept) {
      return;
    }
    await File(url).delete();
    _getRecordings();
  }

  void _handlePlayback(int index) {
    if (_isPlaying) {
      if (_currentRecording == index) {
        if (_isPaused) {
          return _resumeRecording();
        }
        return _pauseRecording();
      }
    }
    _playRecording(_recordings[index].url);
    _currentRecording = index;
  }

  Future<void> _getRecordings() async {
    Directory? recordingsDir = await getExternalStorageDirectory();
    String recordingsPath = '${recordingsDir?.path}/Recordings';
    recordingsDir = Directory(recordingsPath);
    if (await recordingsDir.exists()) {
      final List<FileSystemEntity> recordings = recordingsDir.listSync();
      if (kDebugMode) {
        print("Checking for recordings in $recordingsPath");
      }
      _recordings.clear();
      for (final recording in recordings) {
        setState(() {
          _recordings.add(Recording(
              recording.path
                  .split("/")[recording.path.split(RegExp('/.')).length - 1],
              recording.path));
        });
      }
    } else {
      if (kDebugMode) {
        print('No recordings found');
      }
    }
  }

  Widget _recordingContainer(Recording recording, int index) {
    return WillPopScope(
        onWillPop: () async {
          _audioPlayer.stop();
          return true;
        },
        child: GestureDetector(
            onTap: () {
              _handlePlayback(index);
            },
            onLongPress: () {
              _deleteRecording(recording.url);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black54),
                borderRadius: BorderRadius.circular(10),
              ),
              height: 100,
              child: ListTile(
                title: Text(recording.name),
                subtitle: Text(recording.url),
                leading: _isPlaying && _currentRecording == index
                    ? const Icon(Icons.music_note_rounded, color: Colors.blue)
                    : const Icon(Icons.audio_file_outlined),
              ),
            )));
  }

  Widget _buildRecordingsList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _recordings.length,
      itemBuilder: (context, index) {
        return _recordingContainer(_recordings[index], index);
      },
    );
  }

  Widget _stopButton() {
    return ElevatedButton(
        onPressed: _stopRecording,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Icon(Icons.stop_circle_outlined, color: Colors.red),
          Text('Stop',
              style: TextStyle(
                fontSize: 20,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              )),
        ]));
  }

  Widget _resumeButton() {
    return ElevatedButton(
        onPressed: _resumeRecording,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Icon(Icons.play_circle_outline, color: Colors.white),
          Text('Resume',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )),
        ]));
  }

  Widget _buttonSwitch() {
    return _isPlaying
        ? _isPaused
            ? _resumeButton()
            : _stopButton()
        : const SizedBox();
  }

  Future<bool?> _promptForDeleteFile() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete this file?'),
        actions: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            icon: const Icon(Icons.delete_forever),
            label: const Text('Delete'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Recordings Library',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 40,
              fontWeight: FontWeight.bold,
            )),
        const SizedBox(height: 20),
        _buttonSwitch(),
        SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black54),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 500,
            child: _buildRecordingsList(),
          ),
        )
      ],
    ));
  }
}
