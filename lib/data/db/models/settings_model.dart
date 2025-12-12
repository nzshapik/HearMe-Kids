import 'package:isar/isar.dart';
part 'settings_model.g.dart';
@collection
class Settings {
  Id id = Isar.autoIncrement;
  late String language; // 'uk' | 'en'
  late int sensitivity; // 0..2
  late int sessionMinutes; // 5/10/15
  late bool insultsTracking;
  late bool painMapWarnings;
}
