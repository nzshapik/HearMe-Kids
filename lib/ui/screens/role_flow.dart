import 'package:flutter/material.dart';

import '../../core/role_storage.dart';
import '../../core/user_role.dart';

// ✅ Import your current "adult" home screen:
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
                'Choose your mode. You can change it later (we’ll add a settings switch).',
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
                'Tip: later we can protect Parent mode with a PIN.',
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
    // We keep your current adult interface as-is:
    // HomeScreen is likely a full Scaffold, so we wrap it in a Stack to overlay a small switch button.
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

class KidHomeScreen extends StatelessWidget {
  const KidHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF0),
        elevation: 0,
        title: const Text(
          'HearMe Kids',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Hi! 😊',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'This is Kid mode. Here we’ll build a fun interface with big buttons and images.',
              style: TextStyle(fontSize: 14, color: Colors.brown),
            ),
            const SizedBox(height: 18),

            _KidBigButton(
              title: 'Talk to the app 🎤',
              subtitle: 'Record your voice and get help',
              icon: Icons.mic_none,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Next: kid voice flow 🙂')),
                );
              },
            ),
            const SizedBox(height: 14),
            _KidBigButton(
              title: 'Calm down 🫧',
              subtitle: 'Breathing, simple exercises',
              icon: Icons.air,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Next: kid calming exercises 🙂')),
                );
              },
            ),

            const Spacer(),
            const Text(
              'We can make this screen fully different from Parent mode.',
              style: TextStyle(fontSize: 12, color: Colors.brown),
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
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
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

class _KidBigButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _KidBigButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(18),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      child: Row(
        children: [
          Container(
            height: 46,
            width: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE3B3),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.brown),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.grey)),
              ],
            ),
          ),
        ],
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
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
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
