import 'package:isar/isar.dart';
part 'stats_model.g.dart';
@collection
class DailyStats {
  Id id = Isar.autoIncrement;
  late DateTime date;
  late int peaks;
  late double avgScore;
  late int deescalationSec;
  late int insultsCount;
}
