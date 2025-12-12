import 'package:flutter/material.dart';
import 'connect_screen.dart';
import 'positive_anchors_screen.dart';

class StartPairingScreen extends StatelessWidget {
  const StartPairingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFEAF4FF),
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
                    const SizedBox(height: 8),

                    // Верхня частина
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Коло з сердечком
                        Center(
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFECFEFF),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8B5CF6).withOpacity(0.25),
                                  blurRadius: 40,
                                  offset: const Offset(0, 26),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 40,
                                color: Color(0xFF8B5CF6),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        const Text(
                          'Pair With Your Partner',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          'HearMe works best when both partners are connected. '
                          'Link your devices to share insights together.',
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        const SizedBox(height: 24),

                        const _PairCard(
                          title: 'Shared Understanding',
                          text:
                              'Both partners see the same analysis, creating mutual awareness and accountability.',
                          tint: Color(0xFF22C55E),
                          icon: Icons.handshake_rounded,
                        ),
                        const SizedBox(height: 16),

                        const _PairCard(
                          title: 'Secure Connection',
                          text:
                              'Your pairing is encrypted and private. Only invited partners can connect.',
                          tint: Color(0xFF8B5CF6),
                          icon: Icons.link_rounded,
                        ),
                        const SizedBox(height: 16),

                        const _PairCard(
                          title: 'Optional Step',
                          text:
                              "You can use HearMe solo and pair later from Settings whenever you're ready.",
                          tint: Color(0xFFFBBF24),
                          icon: Icons.fast_forward_rounded,
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
                              // Ідемо до екрану підключення партнера
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const ConnectScreen(),
                                ),
                              );
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
                            child: const Text('Start Pairing'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () {
                            // Якщо скіпаємо паринг – одразу до Positive Anchors
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PositiveAnchorsScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Skip for Now',
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

class _PairCard extends StatelessWidget {
  final String title;
  final String text;
  final Color tint;
  final IconData icon;

  const _PairCard({
    required this.title,
    required this.text,
    required this.tint,
    required this.icon,
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