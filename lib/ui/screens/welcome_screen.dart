import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE9FFF7),
              Color(0xFFF9FAFB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 12),
                    // центр
                    Column(
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF4BC59E).withOpacity(0.14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF4BC59E).withOpacity(0.3),
                                blurRadius: 40,
                                spreadRadius: 4,
                                offset: const Offset(0, 22),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.auto_awesome_rounded,
                              size: 42,
                              color: Color(0xFF36A67F),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'HearMe',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Your Relationship's Safe Space",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'HearMe listens to your conversations and helps you understand emotional patterns, reduce conflict, and build deeper connection.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const _Bullet(
                          text: '100% private • Local processing',
                        ),
                        const SizedBox(height: 10),
                        const _Bullet(
                          text: 'AI-powered insights for couples',
                        ),
                        const SizedBox(height: 10),
                        const _Bullet(
                          text: 'Peaceful conflict resolution',
                        ),
                      ],
                    ),

                    // кнопка
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/permissions');
                            },
                            style: FilledButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: const Color(0xFF41C593),
                              foregroundColor: const Color(0xFF022C22),
                            ),
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;

  const _Bullet({required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircleAvatar(
          radius: 14,
          backgroundColor: Color(0xFFE5F7EF),
          child: Icon(
            Icons.check_rounded,
            size: 18,
            color: Color(0xFF059669),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }
}