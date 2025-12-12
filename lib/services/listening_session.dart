import 'dart:async';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../ml/emotion_detector.dart';
import '../ml/vad.dart';
import '../core/utils/audio_features.dart';
import '../core/utils/smoothing.dart';

final listeningSessionProvider = Provider<ListeningSession>((ref) => ListeningSession(RandomEmotionDetector()));

class ListeningSession {
  final EmotionDetector detector;
  StreamSubscription? _mic;
  final _vad = SimpleVAD();
  final _ema = EMA(0.3);
  bool _running = false;
  ListeningSession(this.detector);

  Future<void> start(Duration duration) async {
    if (_running) return;
    _running = true;
    await detector.load();
    _mic = Stream.periodic(const Duration(milliseconds: 40), (_) {
      return List<double>.generate(640, (i) => (i % 20 == 0 ? 0.1 : 0.0)); // фейковий фрейм
    }).listen((frame) {
      if (!_vad.isVoice(frame)) return;
      final mfcc = AudioFeatures.mfcc(frame);
      final score = detector.predict(mfcc);
      final _ = _ema.next(score);
      // TODO: тригерити втручання з cooldown
    });
    Future.delayed(duration, () => stop());
  }

  Future<void> stop() async {
    if (!_running) return;
    await _mic?.cancel(); _mic = null; _running = false;
    // TODO: зберегти статистику сесії
  }
}
