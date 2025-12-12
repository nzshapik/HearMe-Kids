import 'package:flutter/material.dart';

class PermissionsScreen extends StatelessWidget {
  const PermissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // без AppBar — весь дизайн усередині body
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE9F7FF), // м'який верхній градієнт
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

                    // Верхня частина екрана
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Коло з мікрофоном
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF8B5CF6).withOpacity(0.14),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withOpacity(0.35),
                                blurRadius: 40,
                                spreadRadius: 4,
                                offset: const Offset(0, 22),
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.mic_rounded,
                              size: 40,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                        const SizedBox(height: 28),

                        const Text(
                          'Microphone Access',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          'HearMe needs microphone access to listen to your conversations and provide real-time emotional support.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF4B5563),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Основна картка з трьома пунктами
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 24,
                                offset: const Offset(0, 18),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _PermissionRow(
                                title: 'Your Privacy Matters',
                                text:
                                    'All audio processing happens on your device. Nothing is sent to external servers.',
                                icon: Icons.lock_rounded,
                                iconColor: Color(0xFF14B8A6),
                              ),
                              SizedBox(height: 16),
                              _PermissionRow(
                                title: 'Real-Time Detection',
                                text:
                                    'We detect emotional tone, tension, and positive moments as they happen.',
                                icon: Icons.track_changes_rounded,
                                iconColor: Color(0xFF8B5CF6),
                              ),
                              SizedBox(height: 16),
                              _PermissionRow(
                                title: "You're In Control",
                                text:
                                    'You can revoke access anytime from Settings or your device preferences.',
                                icon: Icons.settings_suggest_rounded,
                                iconColor: Color(0xFFF59E0B),
                              ),
                            ],
                          ),
                        ),
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
                              // після дозволу показуємо екран про приватність
                              Navigator.pushNamed(context, '/privacy');
                            },
                            style: FilledButton.styleFrom(
                              shape: const StadiumBorder(),
                              backgroundColor: const Color(0xFF8B5CF6),
                              foregroundColor: Colors.white,
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            child: const Text('Allow Microphone Access'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            // Back — повертаємося на Welcome
                            Navigator.pop(context);
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

class _PermissionRow extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;
  final Color iconColor;

  const _PermissionRow({
    required this.title,
    required this.text,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: iconColor.withOpacity(0.12),
          child: Icon(
            icon,
            size: 20,
            color: iconColor,
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
    );
  }
}