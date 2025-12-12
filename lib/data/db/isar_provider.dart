import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'models/settings_model.dart';
import 'models/pain_tag_model.dart';
import 'models/anchor_model.dart';
import 'models/stats_model.dart';
import 'models/insult_counter_model.dart';

final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    schemas: [SettingsSchema, PainTagSchema, AnchorItemSchema, DailyStatsSchema, InsultCounterSchema],
    directory: dir.path,
    inspector: false,
  );
});
