class EMA {
  final double alpha;
  double? _last;
  EMA(this.alpha);
  double next(double x) {
    _last = _last == null ? x : (alpha * x + (1 - alpha) * _last!);
    return _last!;
  }
}
