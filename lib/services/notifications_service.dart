import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum InterventionType { pauseBreath, gratitudeReminder, showPhoto, softQuote }

class NotificationsService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInit = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(initSettings);
  }
  static Future<void> showIntervention(InterventionType type, {String? personalizedText, String? photoUri}) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'hearme_interventions','Interventions',importance: Importance.max, priority: Priority.high,
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    final title = switch (type) {
      InterventionType.pauseBreath => 'Зроби паузу і вдих',
      InterventionType.gratitudeReminder => 'Згадай 1 хорошу річ',
      InterventionType.showPhoto => 'Подивись на свій якір',
      InterventionType.softQuote => 'Ніжне нагадування',
    };
    final body = personalizedText ?? 'Ти все контролюєш. Маленький крок зараз — велика різниця згодом.';
    await _plugin.show(DateTime.now().millisecondsSinceEpoch ~/ 1000, title, body, details);
  }
}
