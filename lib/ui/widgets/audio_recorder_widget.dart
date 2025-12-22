import 'dart:async';

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
  bool _isRecordingPaused = false;
  bool _isPlaying = false;
  String? _filePath;

  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;
  StreamSubscription<void>? _playerCompleteSub;

  @override
  void dispose() {
    _ticker?.cancel();
    _playerCompleteSub?.cancel();
    _player.dispose();
    _recorder.dispose();
    super.dispose();
  }

  Future<String> _newFilePath() async {
    final dir = await getApplicationDocumentsDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '${dir.path}/hearme_recording_$ts.m4a';
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void _stopTicker() {
    _ticker?.cancel();
    _ticker = null;
  }

  String _fmt(Duration d) {
    final mm = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final ss = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  String get _timeLabel {
    final d = _stopwatch.elapsed;
    return _fmt(d);
  }

  Future<void> _start() async {
    // If something is playing, stop it.
    if (_isPlaying) {
      await _player.stop();
      if (mounted) setState(() => _isPlaying = false);
    }

    final hasPerm = await _recorder.hasPermission();
    if (!hasPerm) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Відсутній дозвіл на мікрофон')),
      );
      return;
    }

    final path = await _newFilePath();
    await _recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
      path: path,
    );

    _stopwatch
      ..reset()
      ..start();
    _startTicker();

    setState(() {
      _isRecording = true;
      _isRecordingPaused = false;
      _filePath = path;
    });
  }

  Future<void> _pauseOrResumeRecording() async {
    if (!_isRecording) return;

    if (_isRecordingPaused) {
      await _recorder.resume();
      _stopwatch.start();
      setState(() => _isRecordingPaused = false);
      return;
    }

    await _recorder.pause();
    _stopwatch.stop();
    setState(() => _isRecordingPaused = true);
  }

  Future<void> _stop() async {
    await _recorder.stop();
    _stopwatch.stop();
    _stopTicker();
    setState(() {
      _isRecording = false;
      _isRecordingPaused = false;
    });
  }

  Future<void> _togglePlay() async {
    if (_filePath == null) return;
    if (_isRecording) return;

    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
      return;
    }

    // Ensure we only subscribe once.
    await _player.stop();
    _playerCompleteSub?.cancel();
    _playerCompleteSub = _player.onPlayerComplete.listen((_) {
      if (!mounted) return;
      setState(() => _isPlaying = false);
    });

    await _player.play(DeviceFileSource(_filePath!));
    setState(() => _isPlaying = true);
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = _filePath != null;
    final canUse = hasFile && !_isRecording && !_isPlaying;
    final canPlay = hasFile && !_isRecording;

    // Small status dot
    final dotColor = _isRecording
        ? (_isRecordingPaused ? Colors.orange : Colors.red)
        : (hasFile ? const Color(0xFF7A3EFE) : Colors.black38);

    final statusText = _isRecording
        ? (_isRecordingPaused ? 'Пауза' : 'Запис')
        : (hasFile ? 'Готово' : 'Голос');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.06)),
      ),
      child: Row(
        children: [
          // Status + timer (always visible)
          Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(statusText, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(width: 10),
          Text(_timeLabel, style: const TextStyle(fontWeight: FontWeight.w900)),
          const SizedBox(width: 10),

          // Controls (scroll if not enough space)
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _MiniIcon(
                    icon: Icons.fiber_manual_record,
                    onTap: _isRecording ? null : _start,
                    activeColor: Colors.red,
                  ),
                  const SizedBox(width: 6),
                  _MiniIcon(
                    icon: _isRecordingPaused ? Icons.play_arrow : Icons.pause,
                    onTap: _isRecording ? _pauseOrResumeRecording : null,
                    activeColor: Colors.orange,
                  ),
                  const SizedBox(width: 6),
                  _MiniIcon(
                    icon: Icons.stop,
                    onTap: _isRecording ? _stop : null,
                    activeColor: Colors.black,
                  ),
                  const SizedBox(width: 10),
                  _MiniIcon(
                    icon: _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    onTap: canPlay ? _togglePlay : null,
                    activeColor: const Color(0xFF7A3EFE),
                  ),
                  const SizedBox(width: 10),
                  _MiniPill(
                    label: 'Використати',
                    onTap: canUse ? () => widget.onRecorded?.call(_filePath!) : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniIcon extends StatelessWidget {
  final IconData icon;
  final Future<void> Function()? onTap;
  final Color activeColor;

  const _MiniIcon({required this.icon, required this.onTap, required this.activeColor});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: enabled ? () => onTap!() : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: enabled ? activeColor.withOpacity(0.10) : Colors.black.withOpacity(0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(enabled ? 0.10 : 0.04)),
        ),
        child: Icon(icon, size: 20, color: enabled ? activeColor : Colors.black26),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;

  const _MiniPill({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: enabled ? const Color(0xFF7A3EFE) : Colors.black.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(fontWeight: FontWeight.w900, color: enabled ? Colors.white : Colors.black38),
        ),
      ),
    );
  }
}