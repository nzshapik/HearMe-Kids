import 'package:isar/isar.dart';
part 'insult_counter_model.g.dart';
@collection
class InsultCounter {
  Id id = Isar.autoIncrement;
  late String lemma;
  late int count;
  late DateTime lastSeenAt;
}
