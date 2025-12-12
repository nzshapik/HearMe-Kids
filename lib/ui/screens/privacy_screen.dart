import 'package:flutter/material.dart';
import 'connect_screen.dart';
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEAF7FF), // м’який блакитний
              Color(0xFFF9FAFB), // світлий низ
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
                    const SizedBox(height: 8),

                    // Верхня частина
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Privacy First, Always',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          "HearMe is designed with your privacy as the top priority. Here's our commitment to you.",
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        SizedBox(height: 24),

                        _PrivacyCard(
                          title: 'Local Processing Only',
                          text:
                              'All AI analysis happens directly on your device. Your conversations never leave your device.',
                          icon: Icons.smartphone_rounded,
                          tint: Color(0xFF38BDF8),
                        ),
                        SizedBox(height: 16),

                        _PrivacyCard(
                          title: 'End-to-End Encryption',
                          text:
                              "Session data is encrypted with your device's secure enclave. Only you can access it.",
                          icon: Icons.vpn_lock_rounded,
                          tint: Color(0xFFA855F7),
                        ),
                        SizedBox(height: 16),

                        _PrivacyCard(
                          title: 'You Control Your Data',
                          text:
                              'Delete any session instantly. Export or clear all data anytime from Settings.',
                          icon: Icons.delete_forever_rounded,
                          tint: Color(0xFFF97316),
                        ),
                        SizedBox(height: 18),

                        _ImportantNote(),
                      ],
                    ),

                    // Нижні кнопки
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton(
                            onPressed: () {
                              // далі йдемо на той самий connect/pairing екран
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ConnectScreen(),
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: Color(0xFF10B981),
                              foregroundColor: Color(0xFF022C22),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('I Understand'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // назад на Microphone Access
                          },
                          child: const Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
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

class _PrivacyCard extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;
  final Color tint;

  const _PrivacyCard({
    required this.title,
    required this.text,
    required this.icon,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: tint.withOpacity(0.12),
            child: Icon(
              icon,
              size: 20,
              color: tint,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.4,
                    color: Color(0xFF4B5563),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImportantNote extends StatelessWidget {
  const _ImportantNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Text(
        'IMPORTANT NOTE\n\nHearMe is a wellness tool, not medical advice. For serious relationship issues, please consult a licensed therapist.',
        style: TextStyle(
          fontSize: 13,
          height: 1.5,
          color: Color(0xFF4B5563),
        ),
      ),
    );
  }
}