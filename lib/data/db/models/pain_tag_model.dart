import 'package:isar/isar.dart';
part 'pain_tag_model.g.dart';
@collection
class PainTag {
  Id id = Isar.autoIncrement;
  late String tag;
  String? note;
  late DateTime createdAt;
}
