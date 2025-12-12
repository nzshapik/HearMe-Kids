import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import '../db/isar_provider.dart';
import '../db/models/settings_model.dart';

final settingsRepoProvider = Provider<SettingsRepo>((ref) => SettingsRepo(ref));

class SettingsRepo {
  final Ref ref;
  SettingsRepo(this.ref);

  Future<Settings> getOrCreate() async {
    final isar = await ref.read(isarProvider.future);
    var s = await isar.settings.where().findFirst();
    if (s == null) {
      s = Settings()
        ..language = 'uk'
        ..sensitivity = 1
        ..sessionMinutes = 10
        ..insultsTracking = false
        ..painMapWarnings = true;
      await isar.writeTxn(() async => await isar.settings.put(s!));
    }
    return s;
  }

  Future<void> save(Settings s) async {
    final isar = await ref.read(isarProvider.future);
    await isar.writeTxn(() async => await isar.settings.put(s));
  }
}
