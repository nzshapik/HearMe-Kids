class SimpleVAD {
  final double energyThreshold;
  final double zcrThreshold;
  SimpleVAD({this.energyThreshold = 0.01, this.zcrThreshold = 0.1});
  bool isVoice(List<double> frame) {
    final energy = _rms(frame);
    final zcr = _zcr(frame);
    return energy > energyThreshold && zcr < 0.5;
  }
  double _rms(List<double> x) { double s=0; for (final v in x) { s+=v*v; } return (s/x.length).toDouble(); }
  double _zcr(List<double> x) { int c=0; for (int i=1;i<x.length;i++){ if((x[i-1]>=0&&x[i]<0)||(x[i-1]<0&&x[i]>=0)) c++; } return c/x.length; }
}
