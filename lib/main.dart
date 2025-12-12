import 'package:flutter/material.dart';

import 'ui/screens/welcome_screen.dart';
import 'ui/screens/permissions_screen.dart';
import 'ui/screens/privacy_screen.dart';
import 'ui/screens/start_pairing_screen.dart';
import 'ui/screens/connect_screen.dart';
import 'ui/screens/share_invite_screen.dart';
import 'ui/screens/pairing_success_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/positive_anchors_screen.dart';
import 'ui/screens/triggers_screen.dart';
import 'ui/screens/listening_screen.dart';
import 'ui/screens/conflict_screen.dart';
import 'ui/screens/save_delete_screen.dart';
import 'ui/screens/ai_therapist_screen.dart';

void main() {
  runApp(const HearMeApp());
}

class HearMeApp extends StatelessWidget {
  const HearMeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HearMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
        ).copyWith(
          primary: const Color(0xFF7C3AED),
          secondary: const Color(0xFF4BC59E),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black87,
            fontSize: 14,
            height: 1.4,
          ),
        ),
      ),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/permissions': (context) => const PermissionsScreen(),
        '/privacy': (context) => const PrivacyScreen(),
        '/start-pairing': (context) => const StartPairingScreen(),
        '/connect': (context) => const ConnectScreen(),
        '/share-invite': (context) => const ShareInviteScreen(),
        '/pairing-success': (context) => PairingSuccessScreen(),
        '/positive-anchors': (context) => const PositiveAnchorsScreen(),
        '/triggers': (context) => const TriggersScreen(),
        '/home': (context) => HomeScreen(),
        '/listening': (context) => const ListeningScreen(),
        '/conflict': (context) => const ConflictScreen(),
        '/save-delete': (context) => const SaveDeleteScreen(),
        '/ai-therapist': (context) => const AiTherapistScreen(),
      },
    );
  }
}