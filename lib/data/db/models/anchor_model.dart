import 'package:isar/isar.dart';
part 'anchor_model.g.dart';
@collection
class AnchorItem {
  Id id = Isar.autoIncrement;
  late String type;       // 'text' | 'photo'
  late String content;    // text або local URI
  String? note;
  late DateTime createdAt;
}
