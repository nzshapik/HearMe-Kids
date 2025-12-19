import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../../core/role_storage.dart';
import '../../core/user_role.dart';
import '../widgets/audio_recorder_widget.dart';

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
                'Хто зараз користується додатком?',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              const Text(
                'Обери режим. Потім можна змінити.',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _RoleCard(
                title: 'Parent',
                subtitle: 'Дорослий інтерфейс: Calm Message, AI Therapist…',
                icon: Icons.shield_outlined,
                onTap: () => _choose(context, UserRole.parent),
              ),
              const SizedBox(height: 14),
              _RoleCard(
                title: 'Kid',
                subtitle: 'Дитячий інтерфейс: прості кнопки, дружній тон…',
                icon: Icons.emoji_emotions_outlined,
                onTap: () => _choose(context, UserRole.kid),
              ),
              const Spacer(),
              const Text(
                'Порада: пізніше можна додати PIN для Parent.',
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
                'Обери, що ти хочеш зараз:',
                style: TextStyle(fontSize: 16, color: Colors.brown),
              ),
              const SizedBox(height: 18),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.0,
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
              const SizedBox(height: 18),
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
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 34)),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 6),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.brown)),
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

// =========================
// Kid screens (UA only) + AI
// =========================

class KidTalkChoiceScreen extends StatefulWidget {
  const KidTalkChoiceScreen({super.key});

  @override
  State<KidTalkChoiceScreen> createState() => _KidTalkChoiceScreenState();
}

class _KidTalkChoiceScreenState extends State<KidTalkChoiceScreen> {
  final TextEditingController _textCtrl = TextEditingController();
  bool _isWorking = false;
  String? _aiHint;

  @override
  void initState() {
    super.initState();
    // Removed controller listener to avoid unnecessary rebuilds.
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _shareText() async {
    final t = _textCtrl.text.trim();
    if (t.isEmpty) return;

    // Open preview instantly (no waiting UI “freeze”)
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KidShareToParentsPreviewScreen(
          initialMessage: t,
          aiFuture: KidAiService.instance.makeParentMessage(childText: t),
        ),
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
        title: const Text('Розкажи, як ти себе почуваєш ☁️', style: TextStyle(fontWeight: FontWeight.w900)),
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
                onTap: () {},
              ),
              const SizedBox(height: 12),
              _ChoiceButton(
                title: 'Сказати вголос 🎤',
                subtitle: '(можна навіть казати погані слова, але ми про це нікому не скажемо 🤭)',
                color: const Color(0xFFE0F7FA),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const KidSayOutLoudScreen()));
                },
              ),
              const SizedBox(height: 12),
              _ChoiceButton(
                title: 'Обрати емоцію 😊',
                subtitle: 'Обери смайлик',
                color: const Color(0xFFEDE7F6),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const KidPickEmotionScreen()));
                },
              ),
              if (_aiHint != null) ...[
                const SizedBox(height: 10),
                Text(_aiHint!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.brown)),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                child: TextField(
                  controller: _textCtrl,
                  maxLines: 5,
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Розкажи про свій день…'),
                ),
              ),
              const SizedBox(height: 12),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _textCtrl,
                builder: (context, value, _) {
                  final canShare = value.text.trim().isNotEmpty && !_isWorking;
                  return SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: canShare ? _shareText : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7A3EFE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isWorking
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Поділитися'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KidSayOutLoudScreen extends StatefulWidget {
  const KidSayOutLoudScreen({super.key});

  @override
  State<KidSayOutLoudScreen> createState() => _KidSayOutLoudScreenState();
}

class _KidSayOutLoudScreenState extends State<KidSayOutLoudScreen> {
  String? _audioPath;
  String? _text;
  bool _isWorking = false;

  Future<void> _onRecorded(String path) async {
    setState(() {
      _audioPath = path;
      _isWorking = true;
    });

    try {
      final t = await KidAiService.instance.transcribeAudio(path);
      if (!mounted) return;
      setState(() => _text = t);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Я запис почув і перетворив у текст')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не вдалося розпізнати голос: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _isWorking = false);
    }
  }

  Future<void> _shareToParents() async {
    final t = (_text ?? '').trim();
    if (t.isEmpty) return;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => KidShareToParentsPreviewScreen(
        initialMessage: t,
        aiFuture: KidAiService.instance.makeParentMessage(childText: t),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text('Сказати вголос 🎤', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 8),
              const Text('Можеш говорити все, що відчуваєш 💛', textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              const Text('Можна навіть казати погані слова,\nале ми про це нікому не скажемо 🤭', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.brown)),
              const SizedBox(height: 18),
              AudioRecorderWidget(onRecorded: _onRecorded),
              if (_isWorking)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                ),
              if (_text != null) ...[
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: Text(_text!, style: const TextStyle(fontSize: 14, height: 1.35)),
                ),
              ],
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isWorking ? null : () => Navigator.of(context).pop(),
                      child: const Text('Назад'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: (_isWorking || (_text ?? '').trim().isEmpty) ? null : _shareToParents,
                      child: const Text('Поділитися з батьками'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (_audioPath == null)
                const Text('Натисни Record → Stop → Use recording', textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: Colors.brown)),
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
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => KidShareToParentsPreviewScreen(
        initialMessage: 'Я зараз відчуваю: $_selected',
        aiFuture: KidAiService.instance.makeParentMessage(childText: 'Я зараз відчуваю: $_selected'),
      ),
    ));
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

class KidShareToParentsPreviewScreen extends StatefulWidget {
  final String initialMessage;
  final Future<String>? aiFuture;

  const KidShareToParentsPreviewScreen({
    super.key,
    required this.initialMessage,
    this.aiFuture,
  });

  @override
  State<KidShareToParentsPreviewScreen> createState() => _KidShareToParentsPreviewScreenState();
}

class _KidShareToParentsPreviewScreenState extends State<KidShareToParentsPreviewScreen> {
  String? _aiMessage;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    final f = widget.aiFuture;
    if (f != null) {
      _loading = true;
      f.then((value) {
        if (!mounted) return;
        setState(() {
          _aiMessage = value;
          _loading = false;
        });
      }).catchError((e) {
        if (!mounted) return;
        setState(() {
          _loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Помилка AI: $e')),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final messageToShow = (_aiMessage ?? widget.initialMessage).trim();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(title: const Text('Для батьків 💛')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Покажи це мамі або татові:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            if (_loading)
              const Text(
                'Я роблю коротке, спокійне повідомлення… ✨',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: SingleChildScrollView(
                  child: Text(messageToShow, style: const TextStyle(fontSize: 16, height: 1.4)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: messageToShow));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Скопійовано')));
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _KidCuriosityBody(),
        ),
      ),
    );
  }
}

class _KidCuriosityBody extends StatefulWidget {
  @override
  State<_KidCuriosityBody> createState() => _KidCuriosityBodyState();
}

class _KidCuriosityBodyState extends State<_KidCuriosityBody> {
  final _q = TextEditingController();
  String? _a;
  bool _loading = false;

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    final question = _q.text.trim();
    if (question.isEmpty) return;
    setState(() {
      _loading = true;
      _a = null;
    });
    try {
      final ans = await KidAiService.instance.answerCuriosity(question);
      if (!mounted) return;
      setState(() => _a = ans);
    } catch (e) {
      if (!mounted) return;
      setState(() => _a = 'Ой, не вийшло 😕 Спробуй ще раз.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Помилка AI: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Запитай будь-що 😊\nНаприклад: «Хто швидше — лев чи ягуар?»',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.brown),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _q,
          decoration: const InputDecoration(
            hintText: 'Твоє питання…',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16)), borderSide: BorderSide.none),
          ),
          onSubmitted: (_) => _ask(),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 48,
          child: ElevatedButton(
            onPressed: _loading ? null : _ask,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7A3EFE),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: _loading
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                  )
                : const Text('Запитати'),
          ),
        ),
        const SizedBox(height: 14),
        if (_a != null)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
            child: Text(_a!, style: const TextStyle(fontSize: 15, height: 1.35)),
          ),
      ],
    );
  }
}

// =========================
// Kid AI service (UA, kid-safe)
// =========================

class KidAiService {
  KidAiService._();
  static final instance = KidAiService._();

  // ⚠️ Dev only. Use the same key you use in CalmMessage/AiTherapist.
  static const String _apiKey = String.fromEnvironment('OPENAI_API_KEY');
  static const String _chatUrl = 'https://api.openai.com/v1/chat/completions';
  static const String _transcribeUrl = 'https://api.openai.com/v1/audio/transcriptions';

  Future<String> makeParentMessage({required String childText}) async {
    final system = '''
Ти — помічник для дітей. Твоє завдання: перетворити дитячі емоційні слова на коротке, ввічливе і зрозуміле повідомлення для батьків українською.
Правила:
- Без лайки, без образ.
- Дуже коротко (2–5 речень).
- Формат: 1) що відчуваю 2) що мені важливо 3) просте прохання.
- Не вигадуй фактів.
''';
    final user = 'Ось слова дитини. Зроби повідомлення для батьків: "$childText"';
    return _chat(systemPrompt: system, userText: user);
  }

  Future<String> answerCuriosity(String question) async {
    final system = '''
Ти добрий і розумний друг для дитини. Відповідай українською дуже просто.
Правила:
- 2–6 коротких речень.
- Без страшних деталей.
- Якщо питання незрозуміле — постав 1 уточнююче.
- Можеш додати 1 цікавинку в кінці.
''';
    return _chat(systemPrompt: system, userText: question);
  }

  Future<String> transcribeAudio(String filePath) async {
    final key = _apiKey.trim();
    if (key.isEmpty || key == 'PASTE_YOUR_OPENAI_API_KEY_HERE') {
      throw Exception('Немає OpenAI ключа для транскрибації');
    }

    final file = File(filePath);
    if (!file.existsSync()) {
      throw Exception('Аудіофайл не знайдено');
    }

    final uri = Uri.parse(_transcribeUrl);
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $key';
    request.fields['model'] = 'whisper-1';
    request.fields['response_format'] = 'json';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final streamed = await request.send();
    final body = await streamed.stream.bytesToString();
    if (streamed.statusCode != 200) {
      throw Exception('Помилка транскрибації: ${streamed.statusCode} – $body');
    }
    final data = jsonDecode(body) as Map<String, dynamic>;
    final text = (data['text'] as String?)?.trim();
    if (text == null || text.isEmpty) throw Exception('Порожній результат');
    return text;
  }

  Future<String> _chat({required String systemPrompt, required String userText}) async {
    final key = _apiKey.trim();
    if (key.isEmpty || key == 'PASTE_YOUR_OPENAI_API_KEY_HERE') {
      throw Exception('Немає OpenAI ключа');
    }

    final uri = Uri.parse(_chatUrl);
    final resp = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $key',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'temperature': 0.6,
        'max_tokens': 220,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userText},
        ],
      }),
    );

    if (resp.statusCode != 200) {
      throw Exception('OpenAI: ${resp.statusCode} – ${resp.body}');
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>;
    final msg = choices.first['message'] as Map<String, dynamic>;
    final content = (msg['content'] as String?)?.trim();
    if (content == null || content.isEmpty) throw Exception('Порожня відповідь AI');
    return content;
  }
}

// =========================
// Shared choice button (used in KidTalkChoiceScreen)
// =========================

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
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.brown),
                  ),
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