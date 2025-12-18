import 'package:flutter/material.dart';

import '../../core/role_storage.dart';
import '../../core/user_role.dart';

// ✅ Parent (adult) home:
import 'home_screen.dart';

class RoleGate extends StatelessWidget {
  const RoleGate({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserRole?>(
      future: RoleStorage.getRole(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const _Splash();
        }

        final role = snap.data;
        if (role == null) return const RoleSelectScreen();

        if (role == UserRole.parent) return const ParentShell();
        return const KidShell();
      },
    );
  }
}

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({super.key});

  Future<void> _choose(BuildContext context, UserRole role) async {
    await RoleStorage.setRole(role);
    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const RoleGate()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Who is using HearMe Kids?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choose your mode. You can change it later.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _RoleCard(
                title: 'Parent',
                subtitle: 'Serious UI: Calm Message, AI Therapist, settings…',
                icon: Icons.shield_outlined,
                onTap: () => _choose(context, UserRole.parent),
              ),
              const SizedBox(height: 14),
              _RoleCard(
                title: 'Kid',
                subtitle: 'Kid UI: big buttons, images, friendly tone…',
                icon: Icons.emoji_emotions_outlined,
                onTap: () => _choose(context, UserRole.kid),
              ),
              const Spacer(),
              const Text(
                'Tip: later we can add PIN for Parent if you want.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ParentShell extends StatelessWidget {
  const ParentShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const HomeScreen(),
        Positioned(
          right: 12,
          top: 12,
          child: SafeArea(
            child: _RoleSwitchChip(
              label: 'Parent',
              onTap: () async {
                await RoleStorage.clearRole();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const RoleGate()),
                  (_) => false,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class KidShell extends StatelessWidget {
  const KidShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const KidHomeScreen(),
        Positioned(
          right: 12,
          top: 12,
          child: SafeArea(
            child: _RoleSwitchChip(
              label: 'Kid',
              onTap: () async {
                await RoleStorage.clearRole();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const RoleGate()),
                  (_) => false,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

// ✅ Kid UI (fully different feel)
class KidHomeScreen extends StatelessWidget {
  const KidHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'HearMe Kids 🌈',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Привіт! 👋',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 6),
              const Text(
                'Що ти хочеш зробити зараз?',
                style: TextStyle(fontSize: 16, color: Colors.brown),
              ),
              const SizedBox(height: 24),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1,
                children: [
                  _KidTile(
                    emoji: '🎤',
                    title: 'Я хочу поговорити',
                    subtitle: 'Розкажи, що ти відчуваєш',
                    color: const Color(0xFFFFE0E0),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('👉 Далі: дитячий voice flow')),
                      );
                    },
                  ),
                  _KidTile(
                    emoji: '🫧',
                    title: 'Я хочу заспокоїтись',
                    subtitle: 'Подихаємо разом',
                    color: const Color(0xFFE0F7FA),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('👉 Далі: breathing screen')),
                      );
                    },
                  ),
                  _KidTile(
                    emoji: '🎮',
                    title: 'Гра для настрою',
                    subtitle: 'Коротка вправа або гра',
                    color: const Color(0xFFEDE7F6),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('👉 Далі: mood game')),
                      );
                    },
                  ),
                  _KidTile(
                    emoji: '⭐️',
                    title: 'Мій настрій',
                    subtitle: 'Швидка позначка',
                    color: const Color(0xFFFFF1C9),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('👉 Далі: mood check-in')),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Тут завжди безпечно 💛',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.brown),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KidTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _KidTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  height: 1.15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KidCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _KidCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 40)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF7A3EFE).withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: const Color(0xFF7A3EFE)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _RoleSwitchChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _RoleSwitchChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(0.70),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.swap_horiz, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(label,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      body: Center(
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}
