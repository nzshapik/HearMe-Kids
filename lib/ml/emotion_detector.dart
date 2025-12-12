import 'dart:math';
abstract class EmotionDetector {
  Future<void> load();
  double predict(List<double> mfccFeatures);
}
class RandomEmotionDetector implements EmotionDetector {
  final _rng = Random();
  @override Future<void> load() async {}
  @override double predict(List<double> mfccFeatures) => _rng.nextDouble();
}
