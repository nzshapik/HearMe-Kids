import 'package:flutter/material.dart';
import 'ui/screens/role_flow.dart';

void main() {
  runApp(const HearMeKidsApp());
}

class HearMeKidsApp extends StatelessWidget {
  const HearMeKidsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RoleGate(),
    );
  }
}
