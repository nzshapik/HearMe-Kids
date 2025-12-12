// lib/ui/screens/save_delete_screen.dart
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SaveDeleteScreen extends StatelessWidget {
  const SaveDeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFFF9FAFB);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFE9F9F5),
                Color(0xFFF7FBFA),
              ],
            ),
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Save this session?',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'You just finished a conflict. Do you want to keep this session in your history or remove it?',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const _ChoiceCard(
                      title: 'Save to History',
                      subtitle:
                          'Keep this session so you can review patterns and progress over time.',
                      icon: Icons.save_alt_rounded,
                      iconColor: Color(0xFF4BC59E),
                      isPrimary: true,
                    ),
                    const SizedBox(height: 16),

                    const _ChoiceCard(
                      title: 'Delete Session',
                      subtitle:
                          'Remove this session completely. Nothing from this conflict will be stored.',
                      icon: Icons.delete_outline_rounded,
                      iconColor: Color(0xFFF97316),
                      isPrimary: false,
                    ),
                    const SizedBox(height: 24),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Your choice only affects what is stored on your device. Audio is never saved and never leaves your phone.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.5,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Back to Home
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/home');
                        },
                        child: const Text(
                          'Skip for now • Go Home',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF4BC59E),
                          ),
                        ),
                      ),
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

// Один card-віджет для двох варіантів
class _ChoiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final bool isPrimary;

  const _ChoiceCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (isPrimary) {
                  // Зберігаємо конфліктну сесію в Sessions → Conflict sessions
                  SessionStore.conflictSessions.add(
                    SavedSession(
                      createdAt: DateTime.now(),
                      type: 'conflict',
                      title: 'Conflict session',
                      details: 'Saved from Listening flow',
                    ),
                  );
                }

                // У будь-якому випадку повертаємось на Home
                Navigator.pushNamed(context, '/home');
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    isPrimary ? const Color(0xFF4BC59E) : const Color(0xFFF3F4F6),
                foregroundColor: isPrimary ? Colors.white : Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
                textStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: Text(isPrimary ? 'Save session' : 'Delete without saving'),
            ),
          ),
        ],
      ),
    );
  }
}