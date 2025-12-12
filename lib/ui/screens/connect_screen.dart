import 'package:flutter/material.dart';

class ConnectScreen extends StatelessWidget {
  const ConnectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6F4FF),
              Color(0xFFF9FAFB),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      const _HeroIcon(),
                      const SizedBox(height: 28),
                      const Text(
                        'Connect With Partner',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Choose how you'd like to pair your devices together.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Once connected, you'll both see shared insights from your conversations.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Card 1 — Generate Invite Link
                      _ConnectOptionCard(
                        tint: const Color(0xFF22C55E),
                        icon: Icons.link_rounded,
                        title: 'Generate Invite Link',
                        text:
                            'Send a secure link to your partner via text or messaging app.',
                        onTap: () {
                          Navigator.pushNamed(context, '/share-invite');
                        },
                      ),
                      const SizedBox(height: 16),

                      // Card 2 — Scan Partner's Code
                      _ConnectOptionCard(
                        tint: const Color(0xFF8B5CF6),
                        icon: Icons.qr_code_scanner_rounded,
                        title: "Scan Partner's Code",
                        text:
                            'If your partner already has a code, scan it now to connect instantly.',
                        onTap: () {
                          // For now we navigate to the same invite screen (later this can open a scanner).
                          Navigator.pushNamed(context, '/share-invite');
                        },
                      ),
                      const SizedBox(height: 24),

                      const _SecurePairingNote(),
                      const SizedBox(height: 24),

                      // 🟩 НОВА кнопка Skip for now — просто йде на наступний екран флоу
                      TextButton(
                        onPressed: () {
                          // TODO: якщо роут іншого екрану має іншу назву —
                          // заміни '/positive-anchors' на твій реальний route name.
                          Navigator.pushNamed(context, '/positive-anchors');
                        },
                        child: const Text(
                          'Skip for now',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Існуюча кнопка Back — лишаємо як було
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Back',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B5563),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFD5FBEA),
            Color(0xFFE3F3FF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF22C55E).withOpacity(0.32),
            blurRadius: 55,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE9FFF5),
              Color(0xFFE5F3FF),
            ],
          ),
        ),
        child: const Center(
          child: Icon(
            Icons.favorite_rounded,
            size: 44,
            color: Color(0xFF16A34A),
          ),
        ),
      ),
    );
  }
}

class _ConnectOptionCard extends StatelessWidget {
  final IconData icon;
  final Color tint;
  final String title;
  final String text;
  final VoidCallback onTap;

  const _ConnectOptionCard({
    required this.icon,
    required this.tint,
    required this.title,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.06),
              blurRadius: 40,
              offset: const Offset(0, 26),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.8),
              blurRadius: 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: tint.withOpacity(0.14),
              ),
              child: Icon(
                icon,
                size: 26,
                color: tint,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 22,
              color: Color(0xFF6B7280),
            ),
          ],
        ),
      ),
    );
  }
}

class _SecurePairingNote extends StatelessWidget {
  const _SecurePairingNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF5F3FF),
            Color(0xFFEFF6FF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.03),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SECURE PAIRING',
            style: TextStyle(
              fontSize: 12,
              letterSpacing: 1.0,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9CA3AF),
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Your connection is end-to-end encrypted. Only devices with the correct code can pair.',
            style: TextStyle(
              fontSize: 13,
              height: 1.5,
              color: Color(0xFF4B5563),
            ),
          ),
        ],
      ),
    );
  }
}