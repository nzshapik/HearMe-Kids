import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class AudioRecorderWidget extends StatefulWidget {
  final void Function(String filePath)? onRecorded;
  const AudioRecorderWidget({super.key, this.onRecorded});

  @override
  State<AudioRecorderWidget> createState() => _AudioRecorderWidgetState();
}

class _AudioRecorderWidgetState extends State<AudioRecorderWidget> {
  final _recorder = AudioRecorder();
  final _player = AudioPlayer();

  bool _isRecording = false;
  bool _isPlaying = false;
  String? _filePath;

  @override
  void dispose() {
    _player.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<String> _newFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/hearme_recording_$ts.m4a';
  }

  Future<void> _start() async {
    final hasPerm = await _recorder.hasPermission();
    if (!hasPerm) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No microphone permission')),
      );
      return;
    }

    final path = await _newFilePath();
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
      path: path,
    );

    setState(() {
      _isRecording = true;
      _filePath = path;
    });
  }

  Future<void> _stop() async {
    await _recorder.stop();
    setState(() => _isRecording = false);
  }

  Future<void> _togglePlay() async {
    if (_filePath == null) return;

    if (_isPlaying) {
      await _player.stop();
      setState(() => _isPlaying = false);
      return;
    }

    await _player.play(DeviceFileSource(_filePath!));
    setState(() => _isPlaying = true);

    _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Voice input', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _isRecording ? null : _start,
                  icon: const Icon(Icons.mic),
                  label: const Text('Record'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isRecording ? _stop : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: (_filePath != null && !_isRecording) ? _togglePlay : null,
                  icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                  label: Text(_isPlaying ? 'Pause' : 'Play'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: (_filePath != null && !_isRecording) ? () => widget.onRecorded?.call(_filePath!) : null,
              child: const Text('Use recording'),
            ),
          ],
        ),
      ),
    );
  }
}