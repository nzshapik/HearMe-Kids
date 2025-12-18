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
                    subtitle: 'Скажи, що відчуваєш',
                    color: const Color(0xFFFFE0E0),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const KidTalkChoiceScreen()),
                      );
                    },
                  ),
                  _KidTile(
                    emoji: '🫧',
                    title: 'Я хочу заспокоїтись',
                    subtitle: 'Подихаємо разом',
                    color: const Color(0xFFE0F7FA),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const KidBreathingScreen()),
                      );
                    },
                  ),
                  _KidTile(
                    emoji: '💛',
                    title: 'Я хочу пояснити батькам',
                    subtitle: 'Вони мене не чують',
                    color: const Color(0xFFFFF3C4),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const KidExplainToParentsScreen()),
                      );
                    },
                  ),
                  _KidTile(
                    emoji: '🧠',
                    title: 'Цікавинки / Питай AI',
                    subtitle: 'Напр: лев чи ягуар?',
                    color: const Color(0xFFEDE7F6),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const KidCuriosityAiScreen()),
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

// =========================
// Kid screens (UA only)
// =========================

class KidTalkChoiceScreen extends StatefulWidget {
  const KidTalkChoiceScreen({super.key});

  @override
  State<KidTalkChoiceScreen> createState() => _KidTalkChoiceScreenState();
}

class _KidTalkChoiceScreenState extends State<KidTalkChoiceScreen> {
  final TextEditingController _textCtrl = TextEditingController();

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  void _shareText() {
    final t = _textCtrl.text.trim();
    if (t.isEmpty) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KidShareToParentsPreviewScreen(message: t),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Розкажи, як ти себе почуваєш ☁️',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Обери спосіб, який тобі найзручніший 😊',
                style: TextStyle(fontSize: 14, color: Colors.brown),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              _ChoiceButton(
                title: 'Написати ✍️',
                subtitle: 'Напиши, що відчуваєш',
                color: const Color(0xFFFFE0E0),
                onTap: () {
                  // просто фокус на поле нижче
                  FocusScope.of(context).requestFocus(FocusNode());
                  Future.delayed(const Duration(milliseconds: 1), () {
                    FocusScope.of(context).requestFocus();
                  });
                },
              ),
              const SizedBox(height: 12),

              _ChoiceButton(
                title: 'Сказати вголос 🎤',
                subtitle: '(можна навіть казати погані слова, але ми про це нікому не скажемо 🤭)',
                color: const Color(0xFFE0F7FA),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const KidSayOutLoudScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),

              _ChoiceButton(
                title: 'Обрати емоцію 😊',
                subtitle: 'Обери смайлик',
                color: const Color(0xFFEDE7F6),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const KidPickEmotionScreen()),
                  );
                },
              ),

              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: TextField(
                  controller: _textCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Розкажи про свій день…',
                  ),
                ),
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _textCtrl.text.trim().isEmpty ? null : _shareText,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A3EFE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Поділитися'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KidSayOutLoudScreen extends StatelessWidget {
  const KidSayOutLoudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Сказати вголос 🎤',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                'Можеш говорити все, що відчуваєш 💛',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Можна навіть казати погані слова,\nале ми про це нікому не скажемо 🤭',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.brown),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('🎤 Запис почнеться тут (наступний крок)')),
                  );
                },
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF7A3EFE),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.mic, size: 80, color: Colors.white),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Натисни і говори', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Скасувати'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Запис збережено 💛')),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Готово'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KidPickEmotionScreen extends StatefulWidget {
  const KidPickEmotionScreen({super.key});

  @override
  State<KidPickEmotionScreen> createState() => _KidPickEmotionScreenState();
}

class _KidPickEmotionScreenState extends State<KidPickEmotionScreen> {
  String? _selected;

  void _share() {
    if (_selected == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KidShareToParentsPreviewScreen(
          message: 'Я зараз відчуваю: $_selected',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emotions = <String>['😊 Радість', '😢 Сум', '😠 Злість', '😟 Тривога', '😳 Сором', '😴 Втома'];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text('Обрати емоцію 😊', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: emotions.map((e) {
                  final selected = _selected == e;
                  return InkWell(
                    onTap: () => setState(() => _selected = e),
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: selected ? const Color(0xFF7A3EFE).withOpacity(0.15) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black.withOpacity(0.06)),
                      ),
                      child: Text(e, style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  );
                }).toList(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _selected == null ? null : _share,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A3EFE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Поділитися'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KidShareToParentsPreviewScreen extends StatelessWidget {
  final String message;
  const KidShareToParentsPreviewScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Для батьків 💛'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Покажи це мамі або татові:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SingleChildScrollView(
                  child: Text(message, style: const TextStyle(fontSize: 16, height: 1.4)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Скопіюємо / поділимося — наступний крок 🙂')),
                  );
                },
                child: const Text('Скопіювати'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KidBreathingScreen extends StatelessWidget {
  const KidBreathingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text('Подихаємо разом 🫧', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: const Center(
        child: Text(
          'Екран дихання з анімацією\n— наступний крок ✅',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class KidExplainToParentsScreen extends StatelessWidget {
  const KidExplainToParentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text('Пояснити батькам 💛', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: const Center(
        child: Text(
          'Екран для повідомлення батькам\n— наступний крок ✅',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class KidCuriosityAiScreen extends StatelessWidget {
  const KidCuriosityAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text('Цікавинки / Питай AI 🧠', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: const Center(
        child: Text(
          'Екран питань до AI\n— наступний крок ✅',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.brown)),
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
