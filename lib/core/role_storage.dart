import 'package:shared_preferences/shared_preferences.dart';
import 'user_role.dart';

class RoleStorage {
  static const _key = 'hearme_user_role';

  static Future<UserRole?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return UserRoleX.fromStorage(prefs.getString(_key));
  }

  static Future<void> setRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, role.storageValue);
  }

  static Future<void> clearRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
