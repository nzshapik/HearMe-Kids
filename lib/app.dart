import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/theme.dart';
import 'core/localization/l10n.dart';
import 'ui/screens/home_screen.dart';

class HearMeApp extends StatelessWidget {
  const HearMeApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HearMe',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      home: const HomeScreen(),
    );
  }
}
