import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/role_storage.dart';
import '../../core/user_role.dart';
import '../widgets/audio_recorder_widget.dart';
import '../../core/kid_ai_service.dart';
import '../../core/kid_prompts.dart';

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
                        MaterialPageRoute(builder: (_) => const KidTalkChatScreen(showStarterPanel: true)),
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
                  _KidTile(
                    emoji: '📚',
                    title: 'Мої сесії',
                    subtitle: 'Збережені розмови',
                    color: const Color(0xFFE8F5E9),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const KidSessionsScreen()),
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

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KidTalkChatScreen(initialUserText: t),
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
          child: ListView(
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
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const KidTalkChatScreen()),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ChoiceButton(
                title: 'Сказати вголос 🎤',
                subtitle: '(можна навіть казати погані слова, але ми про це нікому не скажемо 🤭)',
                color: const Color(0xFFE0F7FA),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const KidTalkChatScreen(openVoicePanel: true),
                    ),
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
                    MaterialPageRoute(builder: (_) => const KidTalkChatScreen(openEmotionPicker: true)),
                  );
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
                          : const Text('Продовжити'),
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

  void _openChat() {
    final t = (_text ?? '').trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KidTalkChatScreen(initialUserText: t),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canGoChat = !_isWorking && (_text ?? '').trim().isNotEmpty;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text('Сказати вголос 🎤', style: TextStyle(fontWeight: FontWeight.w900)),
      ),

      // ✅ Bottom actions (prevents overflow)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
                      onPressed: canGoChat ? _openChat : null,
                      child: const Text('В чат 💬'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Після запису ми перетворимо голос у текст і ти зможеш продовжити розмову в чаті 💛',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.brown),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 8),
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
            if (_audioPath == null) ...[
              const SizedBox(height: 10),
              const Text(
                'Натисни Record → Stop → Use recording',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.brown),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ChatMsg {
  final bool isUser;
  final String text;
  final File? image;
  _ChatMsg({required this.isUser, required this.text, this.image});
}

class KidTalkChatScreen extends StatefulWidget {
  final String? initialUserText;
  final bool openVoicePanel;
  final bool openEmotionPicker;
  final bool showStarterPanel;

  const KidTalkChatScreen({
    super.key,
    this.initialUserText,
    this.openVoicePanel = false,
    this.openEmotionPicker = false,
    this.showStarterPanel = false,
  });

  @override
  State<KidTalkChatScreen> createState() => _KidTalkChatScreenState();
}

class _KidTalkChatScreenState extends State<KidTalkChatScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _inputFocus = FocusNode();
  final _picker = ImagePicker();

  final List<_ChatMsg> _msgs = [];
  File? _pendingImage;
  bool _loading = false;
  bool _voiceOpen = false;
  bool _voiceWorking = false;

  @override
  void initState() {
    super.initState();
    _voiceOpen = widget.openVoicePanel;
    if (widget.openEmotionPicker) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _openEmotionPicker();
      });
    }
    final initial = (widget.initialUserText ?? '').trim();

    if (initial.isNotEmpty) {
      _msgs.add(_ChatMsg(isUser: true, text: initial));
      _askAi(initial);
    } else {
      _msgs.add(
        _ChatMsg(
          isUser: false,
          text: 'Я тут 💛 Розкажи, що сталося?\n(Можеш написати або додати фото.)',
        ),
      );
    }
  }
  String _defaultSessionTitle() {
    const days = ['Понеділок', 'Вівторок', 'Середа', 'Четвер', "П'ятниця", 'Субота', 'Неділя'];
    final now = DateTime.now();
    final day = days[(now.weekday - 1).clamp(0, 6)];
    final dd = now.day.toString().padLeft(2, '0');
    final mm = now.month.toString().padLeft(2, '0');
    final yyyy = now.year.toString();
    return '$day • $dd.$mm.$yyyy';
  }

  Future<void> _saveSession() async {
    final suggested = _defaultSessionTitle();
    final ctrl = TextEditingController(text: suggested);

    final title = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Зберегти сесію'),
          content: TextField(
            controller: ctrl,
            decoration: const InputDecoration(
              hintText: 'Назва (можна змінити)',
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: const Text('Скасувати')),
            ElevatedButton(onPressed: () => Navigator.of(ctx).pop(ctrl.text.trim()), child: const Text('Зберегти')),
          ],
        );
      },
    );

    if (title == null) return;

    final payload = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'createdAt': DateTime.now().toIso8601String(),
      'title': title.isEmpty ? suggested : title,
      'messages': _msgs
          .map((m) => {
                'role': m.isUser ? 'user' : 'assistant',
                'text': m.text,
                'imagePath': m.image?.path,
              })
          .toList(),
    };

    final f = await _kidSessionsFile();
    List<dynamic> all = [];
    if (await f.exists()) {
      try {
        all = jsonDecode(await f.readAsString()) as List<dynamic>;
      } catch (_) {
        all = [];
      }
    }
    all.add(payload);
    await f.writeAsString(jsonEncode(all));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✅ Сесію збережено'),
        action: SnackBarAction(
          label: 'Відкрити',
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const KidSessionsScreen()),
            );
          },
        ),
      ),
    );
  }

  Future<void> _onVoiceRecorded(String path) async {
    if (_voiceWorking) return;
    setState(() => _voiceWorking = true);

    try {
      final t = await KidAiService.instance.transcribeAudio(path);
      if (!mounted) return;
      final text = t.trim();
      if (text.isEmpty) return;

      setState(() {
        _msgs.add(_ChatMsg(isUser: true, text: text));
      });
      _scrollToBottom();
      await _askAi(text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не вдалося розпізнати голос: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _voiceWorking = false);
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _inputFocus.dispose();
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _openEmotionPicker() async {
    FocusScope.of(context).unfocus();

    final emotions = <String>[
      '😊 Радість',
      '😢 Сум',
      '😠 Злість',
      '😟 Тривога',
      '😳 Сором',
      '😴 Втома',
    ];

    final picked = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: const Color(0xFFFFF6D8),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                const SizedBox(height: 12),
                const Text('Обери емоцію 😊', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: emotions
                      .map(
                        (e) => InkWell(
                          onTap: () => Navigator.of(ctx).pop(e),
                          borderRadius: BorderRadius.circular(18),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.black.withOpacity(0.06)),
                            ),
                            child: Text(e, style: const TextStyle(fontWeight: FontWeight.w800)),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked == null) return;

    final msg = 'Я зараз відчуваю: $picked';
    setState(() {
      _msgs.add(_ChatMsg(isUser: true, text: msg));
    });
    _scrollToBottom();
    await _askAi(msg);
  }

  Future<void> _pickPhoto() async {
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x == null) return;
    setState(() => _pendingImage = File(x.path));
    _scrollToBottom();
  }

  void _removePhoto() {
    setState(() => _pendingImage = null);
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final t = _ctrl.text.trim();
    final img = _pendingImage;
    if (t.isEmpty && img == null) return;

    setState(() {
      _msgs.add(_ChatMsg(isUser: true, text: t.isEmpty ? '📷 (фото)' : t, image: img));
      _ctrl.clear();
      _pendingImage = null;
    });
    _scrollToBottom();

    await _askAi(t.isEmpty ? 'Я додав(ла) фото.' : t);
  }

  Future<void> _askAi(String userText) async {
    if (_loading) return;
    setState(() => _loading = true);
    _scrollToBottom();

    try {
      final reply = await KidAiService.instance.supportKidChat(
        userText,
        systemPrompt: KidPrompts.currentKidTalkPrompt,
        promptVersion: KidPrompts.currentKidTalkKey,
      );
      if (!mounted) return;
      setState(() => _msgs.add(_ChatMsg(isUser: false, text: reply)));
    } catch (e) {
      if (!mounted) return;
      setState(() => _msgs.add(_ChatMsg(isUser: false, text: 'Ой, щось не вийшло 😕 Спробуй ще раз.')));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Помилка AI: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text('Чат 💬', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const KidSessionsScreen()),
              );
            },
            child: const Text('Сесії', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
          TextButton(
            onPressed: _msgs.isEmpty ? null : _saveSession,
            child: const Text('Зберегти', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Show a small, transparent emotion hint chip at the top if first message is from assistant
            if (_msgs.length == 1 && !_msgs.first.isUser)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 6),
                child: Center(
                  child: InkWell(
                    onTap: _openEmotionPicker,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.35),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black.withOpacity(0.08)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text(
                            'Можеш обрати емоцію 😊',
                            style: TextStyle(fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Можеш казати мені все, навіть погані слова — ми нікому не скажемо 🤭',
                            style: TextStyle(fontSize: 11, color: Colors.black54),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                itemCount: _msgs.length + (_loading ? 1 : 0),
                itemBuilder: (context, i) {
                  if (_loading && i == _msgs.length) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('…', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                      ),
                    );
                  }

                  final m = _msgs[i];
                  final align = m.isUser ? Alignment.centerRight : Alignment.centerLeft;
                  final bg = m.isUser ? const Color(0xFF7A3EFE) : Colors.white;
                  final fg = m.isUser ? Colors.white : Colors.black;

                  return Align(
                    alignment: align,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 320),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(16),
                        border: m.isUser ? null : Border.all(color: Colors.black.withOpacity(0.06)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (m.image != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(m.image!, height: 140, width: 240, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Text(m.text, style: TextStyle(color: fg, height: 1.35, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_voiceOpen)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black.withOpacity(0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Записати вголос 🎤', style: TextStyle(fontWeight: FontWeight.w900)),
                          ),
                          IconButton(
                            onPressed: _voiceWorking ? null : () => setState(() => _voiceOpen = false),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AudioRecorderWidget(onRecorded: _onVoiceRecorded),
                      if (_voiceWorking)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Center(
                            child: SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                        ),
                      const SizedBox(height: 6),
                      const Text(
                        'Запиши думку, а я перетворю її в текст і ми продовжимо розмову 💛',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.brown),
                      ),
                    ],
                  ),
                ),
              ),

            if (_pendingImage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_pendingImage!, height: 54, width: 54, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('Фото додано', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    IconButton(onPressed: _removePhoto, icon: const Icon(Icons.close)),
                  ],
                ),
              ),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _loading ? null : () => setState(() => _voiceOpen = !_voiceOpen),
                      icon: const Icon(Icons.mic, size: 18),
                      label: const Text('Голос'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(onPressed: _pickPhoto, icon: const Icon(Icons.photo)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.black.withOpacity(0.06)),
                        ),
                        child: TextField(
                          controller: _ctrl,
                          focusNode: _inputFocus,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Напиши…',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _send,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A3EFE),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Send'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

  void _continueToChat() {
    if (_selected == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KidTalkChatScreen(initialUserText: 'Я зараз відчуваю: $_selected'),
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
                  onPressed: _selected == null ? null : _continueToChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7A3EFE),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Продовжити'),
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
  final String messageToParents;

  const KidShareToParentsPreviewScreen({
    super.key,
    required this.messageToParents,
  });

  @override
  Widget build(BuildContext context) {
    final messageToShow = messageToParents.trim();

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


class KidExplainToParentsScreen extends StatefulWidget {
  const KidExplainToParentsScreen({super.key});

  @override
  State<KidExplainToParentsScreen> createState() => _KidExplainToParentsScreenState();
}

class _KidExplainToParentsScreenState extends State<KidExplainToParentsScreen> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  final _inputFocus = FocusNode();
  final _picker = ImagePicker();

  final List<_ChatMsg> _msgs = [];
  String? _cachedParentsLetter;
  int? _parentPlaceholderIndex;
  File? _pendingImage;

  bool _loading = false;
  bool _voiceOpen = false;
  bool _voiceWorking = false;

  @override
  void initState() {
    super.initState();
    _msgs.add(
      _ChatMsg(
        isUser: false,
        text: 'Я допоможу тобі пояснити батькам 💛\nНапиши або запиши вголос, що сталося.',
      ),
    );
  }

  @override
  void dispose() {
    _inputFocus.dispose();
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _pickPhoto() async {
    final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (x == null) return;
    setState(() => _pendingImage = File(x.path));
    _scrollToBottom();
  }

  void _removePhoto() {
    setState(() => _pendingImage = null);
  }

  Future<void> _send() async {
    final t = _ctrl.text.trim();
    final img = _pendingImage;
    if (t.isEmpty && img == null) return;

    setState(() {
      _msgs.add(_ChatMsg(isUser: true, text: t.isEmpty ? '📷 (фото)' : t, image: img));
      _ctrl.clear();
      _pendingImage = null;
      _voiceOpen = false;
      _cachedParentsLetter = null;
      _parentPlaceholderIndex = null;
    });
    _scrollToBottom();

    await _askAi(t.isEmpty ? 'Я додав(ла) фото.' : t);
  }

  Future<void> _askAi(String userText) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _parentPlaceholderIndex = null;
    });
    _scrollToBottom();

    try {
      // 1) FAST: kid-facing support
      final kidReply = await KidAiService.instance.makeExplainParentsKidMessageQuick(
        childText: userText,
      );
      if (!mounted) return;

      final kidMsg = kidReply.trim();

      setState(() {
        if (kidMsg.isNotEmpty) {
          _msgs.add(_ChatMsg(isUser: false, text: kidMsg));
        }

        // Show a placeholder for parent letter while it is being generated.
        _parentPlaceholderIndex = _msgs.length;
        _msgs.add(
          _ChatMsg(
            isUser: false,
            text: '✍️ Я готую спокійне повідомлення для батьків…',
          ),
        );
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _msgs.add(_ChatMsg(isUser: false, text: 'Ой, щось не вийшло 😕 Спробуй ще раз.'));
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Помилка AI: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _loading = false);
      _scrollToBottom();
    }

    // 2) SLOWER: parent-facing letter (do not block UI)
    // ignore: unawaited_futures
    Future<void>(() async {
      try {
        final parentLetter = await KidAiService.instance.makeExplainParentsParentLetterSlow(
          childText: userText,
        );
        if (!mounted) return;

        final letter = parentLetter.trim();
        if (letter.isEmpty) return;

        setState(() {
          _cachedParentsLetter = letter;

          final idx = _parentPlaceholderIndex;
          if (idx != null && idx >= 0 && idx < _msgs.length) {
            _msgs[idx] = _ChatMsg(
              isUser: false,
              text: '💛 Для батьків (скопіюй):\n\n$letter',
            );
          } else {
            _msgs.add(
              _ChatMsg(
                isUser: false,
                text: '💛 Для батьків (скопіюй):\n\n$letter',
              ),
            );
          }
        });

        _scrollToBottom();
      } catch (e) {
        if (!mounted) return;
        setState(() {
          final idx = _parentPlaceholderIndex;
          if (idx != null && idx >= 0 && idx < _msgs.length) {
            _msgs[idx] = _ChatMsg(
              isUser: false,
              text: 'Не вдалося підготувати повідомлення для батьків 😕',
            );
          }
        });
      }
    });
  }

  Future<void> _onVoiceRecorded(String path) async {
    if (_voiceWorking) return;
    setState(() => _voiceWorking = true);

    try {
      final t = await KidAiService.instance.transcribeAudio(path);
      if (!mounted) return;
      final text = t.trim();
      if (text.isEmpty) return;

      setState(() {
        _msgs.add(_ChatMsg(isUser: true, text: text));
        _voiceOpen = false;
        _cachedParentsLetter = null;
        _parentPlaceholderIndex = null;
      });
      _scrollToBottom();
      await _askAi(text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Не вдалося розпізнати голос: $e')));
    } finally {
      if (!mounted) return;
      setState(() => _voiceWorking = false);
      _scrollToBottom();
    }
  }

  Future<void> _share() async {
    // Build the child text only from user messages.
    final parts = _msgs.where((m) => m.isUser).map((m) => m.text.trim()).where((t) => t.isNotEmpty).toList();
    final childText = parts.join('\n');
    if (childText.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Спочатку напиши або запиши щось 💛')));
      return;
    }

    FocusScope.of(context).unfocus();

    final msgForParents = (_cachedParentsLetter ?? '').trim().isNotEmpty
        ? _cachedParentsLetter!.trim()
        : childText.trim();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => KidShareToParentsPreviewScreen(
          messageToParents: msgForParents,
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
        title: const Text('Пояснити батькам 💛', style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          TextButton(
            onPressed: _share,
            child: const Text('Для батьків', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Small transparent hint
            if (_msgs.length == 1 && !_msgs.first.isUser)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 6),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.35),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black.withOpacity(0.08)),
                    ),
                    child: const Text(
                      'Можеш казати мені все — я допоможу сформулювати для мами/тата 😊',
                      style: TextStyle(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

            Expanded(
              child: ListView.builder(
                controller: _scroll,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                itemCount: _msgs.length + (_loading ? 1 : 0),
                itemBuilder: (context, i) {
                  if (_loading && i == _msgs.length) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 6),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('…', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                      ),
                    );
                  }

                  final m = _msgs[i];
                  final align = m.isUser ? Alignment.centerRight : Alignment.centerLeft;
                  final bg = m.isUser ? const Color(0xFF7A3EFE) : Colors.white;
                  final fg = m.isUser ? Colors.white : Colors.black;

                  return Align(
                    alignment: align,
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 320),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(16),
                        border: m.isUser ? null : Border.all(color: Colors.black.withOpacity(0.06)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (m.image != null) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(m.image!, height: 140, width: 240, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Text(m.text, style: TextStyle(color: fg, height: 1.35, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            if (_voiceOpen)
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.black.withOpacity(0.06)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text('Голос 🎤', style: TextStyle(fontWeight: FontWeight.w900)),
                          ),
                          IconButton(
                            onPressed: _voiceWorking ? null : () => setState(() => _voiceOpen = false),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),
                      AudioRecorderWidget(onRecorded: _onVoiceRecorded),
                      if (_voiceWorking)
                        const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Center(
                            child: SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

            if (_pendingImage != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_pendingImage!, height: 54, width: 54, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text('Фото додано', style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    IconButton(onPressed: _removePhoto, icon: const Icon(Icons.close)),
                  ],
                ),
              ),

            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _loading ? null : () => setState(() => _voiceOpen = !_voiceOpen),
                      icon: const Icon(Icons.mic, size: 18),
                      label: const Text('Голос'),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(onPressed: _pickPhoto, icon: const Icon(Icons.photo)),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: Colors.black.withOpacity(0.06)),
                        ),
                        child: TextField(
                          controller: _ctrl,
                          focusNode: _inputFocus,
                          minLines: 1,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Напиши…',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _send,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7A3EFE),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Send'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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

// =======================
// ✅ Kid Sessions (Local)
// =======================

Future<File> _kidSessionsFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/kid_sessions.json');
}

Future<List<Map<String, dynamic>>> _loadKidSessions() async {
  final f = await _kidSessionsFile();
  if (!await f.exists()) return [];
  try {
    final raw = jsonDecode(await f.readAsString());
    if (raw is! List) return [];
    return raw.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
  } catch (_) {
    return [];
  }
}

Future<void> _saveKidSessions(List<Map<String, dynamic>> sessions) async {
  final f = await _kidSessionsFile();
  await f.writeAsString(jsonEncode(sessions));
}

DateTime _parseIso(String? s) {
  if (s == null) return DateTime.fromMillisecondsSinceEpoch(0);
  try {
    return DateTime.parse(s);
  } catch (_) {
    return DateTime.fromMillisecondsSinceEpoch(0);
  }
}

class KidSessionsScreen extends StatefulWidget {
  const KidSessionsScreen({super.key});

  @override
  State<KidSessionsScreen> createState() => _KidSessionsScreenState();
}

class _KidSessionsScreenState extends State<KidSessionsScreen> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadKidSessions();
  }

  Future<void> _refresh() async {
    setState(() => _future = _loadKidSessions());
  }

  String _niceTime(String iso) {
    final dt = _parseIso(iso);
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString();
    final hh = dt.hour.toString().padLeft(2, '0');
    final mi = dt.minute.toString().padLeft(2, '0');
    return '$dd.$mm.$yyyy  $hh:$mi';
  }

  Future<void> _delete(String id) async {
    final sessions = await _loadKidSessions();
    sessions.removeWhere((s) => (s['id']?.toString() ?? '') == id);
    await _saveKidSessions(sessions);
    if (!mounted) return;
    await _refresh();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🗑️ Видалено')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: const Text('Мої сесії 📚', style: TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator(strokeWidth: 2));
          }

          final sessions = (snap.data ?? []).toList();
          // ✅ Sort: newest first (today will be at the top)
          sessions.sort((a, b) {
            final ad = _parseIso(a['createdAt']?.toString());
            final bd = _parseIso(b['createdAt']?.toString());
            return bd.compareTo(ad);
          });

          if (sessions.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 120),
                  Center(child: Text('Поки що немає збережених сесій 💛')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final s = sessions[i];
                final id = s['id']?.toString() ?? '';
                final title = (s['title']?.toString() ?? 'Сесія').trim();
                final createdAt = s['createdAt']?.toString() ?? '';
                final messages = (s['messages'] is List) ? (s['messages'] as List) : const [];
                final count = messages.length;

                return Dismissible(
                  key: ValueKey(id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.delete, color: Colors.red),
                  ),
                  confirmDismiss: (_) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Видалити сесію?'),
                            content: Text('"$title"'),
                            actions: [
                              TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Ні')),
                              ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Так')),
                            ],
                          ),
                        ) ??
                        false;
                  },
                  onDismissed: (_) => _delete(id),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => KidSessionDetailScreen(session: s)),
                      );
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black.withOpacity(0.06)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 42,
                            width: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7A3EFE).withOpacity(0.10),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF7A3EFE)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                                const SizedBox(height: 4),
                                Text(
                                  '${_niceTime(createdAt)} • повідомлень: $count',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class KidSessionDetailScreen extends StatelessWidget {
  final Map<String, dynamic> session;

  const KidSessionDetailScreen({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final title = (session['title']?.toString() ?? 'Сесія').trim();
    final createdAt = session['createdAt']?.toString() ?? '';
    final messages = (session['messages'] is List) ? (session['messages'] as List) : const [];

    return Scaffold(
      backgroundColor: const Color(0xFFFFF6D8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF6D8),
        elevation: 0,
        centerTitle: true,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (createdAt.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                createdAt,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.brown),
              ),
            ),
          for (final m in messages)
            if (m is Map)
              _SessionBubble(
                isUser: (m['role']?.toString() ?? '') == 'user',
                text: (m['text']?.toString() ?? '').trim(),
                imagePath: m['imagePath']?.toString(),
              ),
        ],
      ),
    );
  }
}

class _SessionBubble extends StatelessWidget {
  final bool isUser;
  final String text;
  final String? imagePath;

  const _SessionBubble({required this.isUser, required this.text, this.imagePath});

  @override
  Widget build(BuildContext context) {
    final bg = isUser ? const Color(0xFF7A3EFE) : Colors.white;
    final fg = isUser ? Colors.white : Colors.black;
    final align = isUser ? Alignment.centerRight : Alignment.centerLeft;

    return Align(
      alignment: align,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16),
          border: isUser ? null : Border.all(color: Colors.black.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imagePath != null && imagePath!.isNotEmpty && File(imagePath!).existsSync()) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(imagePath!), height: 140, width: 240, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
            ],
            if (text.isNotEmpty)
              Text(
                text,
                style: TextStyle(color: fg, height: 1.35, fontWeight: FontWeight.w600),
              ),
          ],
        ),
      ),
    );
  }
}