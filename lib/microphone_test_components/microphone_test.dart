import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:flutter/material.dart';
import 'package:mob_app_dev/item_page_components/item_button.dart';

class TitleItem {
  String char;
  TextStyle style;
  TitleItem(this.char, this.style);
}

List<Color> colors = [
  Colors.black,
  Colors.yellow,
  Colors.orange,
  Colors.red,
];

class MicrophoneTest extends StatefulWidget {
  const MicrophoneTest({
    super.key,
  });
  @override
  State<MicrophoneTest> createState() => _MicrophoneTestState();
}

class _MicrophoneTestState extends State<MicrophoneTest> {
  bool _isMicOn = false;
  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;
  final String _titleOrig = "Microphone Test";
  final List<TitleItem> _title = [
    TitleItem("M", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("i", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("c", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("r", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("o", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("p", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("h", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("o", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("n", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("e", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem(" ", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("t", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("e", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("s", const TextStyle(color: Colors.black, fontSize: 40)),
    TitleItem("t", const TextStyle(color: Colors.black, fontSize: 40)),
  ];

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) => setState(() => _amplitude = amp));

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();

        await _audioRecorder.start();
        _recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Color _getElementColor() {
    double? current = _amplitude?.current;
    if (current != null) {
      if (current > -3.0) {
        return Colors.red;
      }
      if (current > -6.0) {
        return Colors.orange;
      }
      if (current > -10.0) {
        return Colors.yellow;
      }
    }
    return Colors.black;
  }

  double _getElementSize() {
    double? current = _amplitude?.current;
    if (current! > -20.0) {
      return 70.0 + (current * 3);
    }
    return 20.0;
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _isMicOn = true);
    int index = 0;
    _setTitleToRecording();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (index < _title.length) {
        setState(() {
          _title[index].char = "|";
          _title[index].style = TextStyle(
            color: _getElementColor(),
            fontSize: _getElementSize(),
          );
        });
        index++;
      } else {
        index = 0;
        _setTitleToRecording();
      }
      setState(() => _recordDuration++);
    });
  }

  void _setTitleToRecording() {
    for (int i = 0; i < _title.length; i++) {
      setState(() {
        _title[i].char = "•";
        _title[i].style = const TextStyle(
          color: Colors.black,
          fontSize: 25,
        );
      });
    }
  }

  void _resetTitleStyle() {
    for (int i = 0; i < _title.length; i++) {
      setState(() {
        _title[i].char = _titleOrig[i];
        _title[i].style = const TextStyle(
          color: Colors.black,
          fontSize: 40,
        );
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<void> _stop() async {
    _timer?.cancel();
    _recordDuration = 0;
    setState(() => _isMicOn = false);
    _resetTitleStyle();
    final path = await _audioRecorder.stop();
    if (path != null) {
      // Prompt the user for a name
      final name = await _promptForRecordingName();

      if (name != null && name.isNotEmpty) {
        _moveFile(path, name);
      } else {
        // If the user did not enter a name, delete the recording file
        await File(path).delete();
      }
    } else {
      throw Exception("Path is null");
    }
  }

  Future<String?> _promptForRecordingName() async {
    final controller = TextEditingController();
    return await showDialog<String?>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Name your recording'),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(controller.text);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  Widget _buildText() {
    if (_recordState == RecordState.pause) {
      return const Text("Pause",
          style: TextStyle(color: Colors.redAccent, fontSize: 40));
    }
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }
    return const Text("Waiting to record",
        style: TextStyle(
          color: Colors.black,
          fontSize: 25,
        ));
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red, fontSize: 40),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  Future<void> _moveFile(String filePath, String newName) async {
    final Directory? newDir = await getExternalStorageDirectory();
    final String newDirectory = '${newDir?.path}/Recordings';
    final file = File(filePath);
    final directory = Directory(newDirectory);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    final newFilePath = '$newDirectory/$newName.${file.path.split('.').last}';
    await file.copy(newFilePath); // Copy the file to the new location
    await file.delete(); // Delete the original file
    print('File moved to $newFilePath');
  }

  Widget _buildButton() {
    if (_isMicOn) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ItemButton(onPressed: _stop, text: 'Stop', size: 120),
          const SizedBox(width: 16),
          _recordState == RecordState.pause
              ? ItemButton(onPressed: _resume, text: 'Resume', size: 120)
              : ItemButton(onPressed: _pause, text: 'Pause', size: 120),
        ],
      );
    }
    return ItemButton(onPressed: _start, text: 'Start', size: 200);
  }

  Widget _buildTimerContainer() {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black),
      ),
      alignment: Alignment.center,
      child: _buildText(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimerContainer(),
        Container(
          height: 130,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _title
                .map((item) => Text(item.char, style: item.style))
                .toList(),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mic,
              size: 100,
              color: _isMicOn ? Colors.red : Colors.black,
            ),
            _buildButton(),
          ],
        ),
      ],
    )));
  }
}
