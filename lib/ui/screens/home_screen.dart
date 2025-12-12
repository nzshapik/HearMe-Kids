import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'conflict_screen.dart';
import 'positive_anchors_screen.dart';
import 'listening_screen.dart';
import 'calm_message_ai_service.dart';
import 'ai_therapist_screen.dart';
import '../widgets/audio_recorder_widget.dart';

class SavedSession {
  final DateTime createdAt;
  final String type; // 'conflict' або 'calm'
  final String title;
  final String details;

  SavedSession({
    required this.createdAt,
    required this.type,
    required this.title,
    required this.details,
  });
}

class SessionStore {
  static final List<SavedSession> conflictSessions = [];
  static final List<SavedSession> calmMessageSessions = [];
}

class CalmMessageScreen extends StatefulWidget {
  const CalmMessageScreen({super.key});

  @override
  State<CalmMessageScreen> createState() => _CalmMessageScreenState();
}

class _CalmMessageScreenState extends State<CalmMessageScreen> {
  final TextEditingController emotionalCtrl = TextEditingController();

  String? _recordedAudioPath;

  bool _isLoading = false;
  String? _errorText;
  List<CalmStyleVariant> _variants = [];
  CalmStyleKey? _preferredStyleKey;

  @override
  void initState() {
    super.initState();
    _loadPreferredStyle();
  }

  @override
  void dispose() {
    emotionalCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadPreferredStyle() async {
    final prefs = CalmStylePreferences.instance;
    final key = await prefs.getPreferredStyle();
    if (!mounted) return;
    setState(() {
      _preferredStyleKey = key;
    });
  }

  Future<void> _onTransformPressed() async {
    final rawText = emotionalCtrl.text.trim();
    if (rawText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please type your message first')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
      _variants = [];
    });

    try {
      if (_preferredStyleKey == null) {
        // Перший запуск або ще немає стилю за замовчуванням → усі 3 варіанти.
        await _generateAllStyles(rawText);
      } else {
        // Є улюблений стиль → генеруємо тільки його.
        await _generateSingleStyle(rawText, _preferredStyleKey!);
      }
    } catch (e) {
      setState(() {
        _errorText = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _generateAllStyles(String rawText) async {
    final service = CalmMessageAiService.instance;
    final prefs = CalmStylePreferences.instance;

    final result = await service.transformAllStyles(rawText);

    final updated = <CalmStyleVariant>[];
    for (final v in result.variants) {
      final label = await prefs.getStyleLabel(v.key);
      updated.add(
        CalmStyleVariant(
          key: v.key,
          label: label,
          text: v.text,
        ),
      );
    }

    if (!mounted) return;
    setState(() {
      _variants = updated;
    });
  }

  Future<void> _generateSingleStyle(String rawText, CalmStyleKey key) async {
    final service = CalmMessageAiService.instance;
    final prefs = CalmStylePreferences.instance;

    final text = await service.transformSingleStyle(rawText, key);
    final label = await prefs.getStyleLabel(key);

    if (!mounted) return;
    setState(() {
      _variants = [
        CalmStyleVariant(
          key: key,
          label: label,
          text: text,
        )
      ];
    });
  }

  Future<void> _onShowOtherStyles() async {
    final rawText = emotionalCtrl.text.trim();
    if (rawText.isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
      _variants = [];
    });

    try {
      await _generateAllStyles(rawText);
    } catch (e) {
      setState(() {
        _errorText = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _setDefaultStyle(CalmStyleKey key) async {
    final prefs = CalmStylePreferences.instance;
    await prefs.setPreferredStyle(key);

    if (!mounted) return;
    setState(() {
      _preferredStyleKey = key;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Стиль збережено як стиль за замовчуванням ✅'),
      ),
    );
  }

  Future<void> _renameStyle(CalmStyleVariant variant) async {
    final controller = TextEditingController(text: variant.label);
    final prefs = CalmStylePreferences.instance;

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Перейменувати стиль'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Нова назва стилю',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Скасувати'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Зберегти'),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) return;

    await prefs.setStyleLabel(variant.key, result);

    if (!mounted) return;
    setState(() {
      _variants = _variants
          .map(
            (v) => v.key == variant.key
                ? CalmStyleVariant(
                    key: v.key,
                    label: result,
                    text: v.text,
                  )
                : v,
          )
          .toList();
    });
  }

  Future<void> _copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Text copied to clipboard 📋')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPreferred = _preferredStyleKey != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calm Message'),
        backgroundColor: const Color(0xFF7C4DFF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AudioRecorderWidget(
              onRecorded: (path) {
                setState(() => _recordedAudioPath = path);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('✅ Voice recorded.')),
                );
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emotionalCtrl,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your emotional message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Transform button
            Center(
              child: GestureDetector(
                onTap: _isLoading ? null : _onTransformPressed,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFB388FF),
                        Color(0xFF7C4DFF),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF7C4DFF).withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoading)
                        const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      else
                        const Icon(
                          Icons.auto_fix_high,
                          color: Colors.white,
                          size: 18,
                        ),
                      const SizedBox(width: 8),
                      Text(
                        _isLoading ? "Transforming..." : "Transform ↓",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            if (_variants.isNotEmpty || _errorText != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI Calm Versions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    hasPreferred
                        ? 'Стиль, який ми використовуємо зараз'
                        : 'Оберіть стиль, який вам підходить',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            if (_errorText != null)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _errorText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red.shade700,
                  ),
                ),
              ),

            Flexible(
              child: _variants.isEmpty
                  ? Center(
                      child: Text(
                        'Your calm message will appear here after transform.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: _variants
                            .map(
                              (v) => _StyleCard(
                                variant: v,
                                isDefault: _preferredStyleKey == v.key,
                                onCopy: () => _copyToClipboard(v.text),
                                onSetDefault: () => _setDefaultStyle(v.key),
                                onRename: () => _renameStyle(v),
                              ),
                            )
                            .toList(),
                      ),
                    ),
            ),

            if (_variants.length == 1 && hasPreferred && !_isLoading)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _onShowOtherStyles,
                  child: const Text('Показати інші стилі'),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else if (index == 1) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const SessionsScreen()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This section is coming soon'),
              ),
            );
          }
        },
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _StyleCard extends StatelessWidget {
  final CalmStyleVariant variant;
  final bool isDefault;
  final VoidCallback onCopy;
  final VoidCallback onSetDefault;
  final VoidCallback onRename;

  const _StyleCard({
    required this.variant,
    required this.isDefault,
    required this.onCopy,
    required this.onSetDefault,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: isDefault ? const Color(0xFF7C4DFF) : Colors.transparent,
          width: 1.4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  variant.label,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E1E2D),
                  ),
                ),
              ),
              if (isDefault)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF7C4DFF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Default',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF7C4DFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              IconButton(
                onPressed: onRename,
                icon: const Icon(
                  Icons.edit,
                  size: 18,
                  color: Colors.grey,
                ),
                tooltip: 'Перейменувати стиль',
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            variant.text,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              height: 1.4,
              color: const Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onCopy,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.grey.shade400,
                      width: 1.2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    "Use now",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: onSetDefault,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C4DFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    isDefault ? 'Default' : 'Set as default',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
        backgroundColor: const Color(0xFF7C4DFF),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          // AI Therapist section
          Text(
            'AI Therapist',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 8),
          if (AiTherapistSessionStore.instance.sessions.isEmpty)
            Text(
              'No AI Therapist sessions yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            )
          else
            Column(
              children: AiTherapistSessionStore.instance.sessions
                  .map(
                    (s) => Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 14,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.question,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E1E2D),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            s.answer,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 13,
                              height: 1.3,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${s.createdAt.year.toString().padLeft(4, '0')}-${s.createdAt.month.toString().padLeft(2, '0')}-${s.createdAt.day.toString().padLeft(2, '0')} '
                            '${s.createdAt.hour.toString().padLeft(2, '0')}:${s.createdAt.minute.toString().padLeft(2, '0')}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),

          const SizedBox(height: 24),

          // Calm Message sessions section
          Text(
            'Calm Messages',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 8),
          if (SessionStore.calmMessageSessions.isEmpty)
            Text(
              'No Calm Message sessions yet.',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            )
          else
            ...SessionStore.calmMessageSessions.map(
              (s) => _SessionTile(session: s),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 1,
        onTap: (index) {
          if (index == 1) {
            return;
          }
          if (index == 0) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else if (index == 1) {
            return;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This section is coming soon'),
              ),
            );
          }
        },
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final SavedSession session;

  const _SessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final created =
        '${session.createdAt.year.toString().padLeft(4, '0')}-${session.createdAt.month.toString().padLeft(2, '0')}-${session.createdAt.day.toString().padLeft(2, '0')} '
        '${session.createdAt.hour.toString().padLeft(2, '0')}:${session.createdAt.minute.toString().padLeft(2, '0')}';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            session.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E1E2D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            session.details,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 13,
              height: 1.3,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            created,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===== Header =====
              Text(
                'HearMe',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF7C4DFF),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Your AI relationship companion',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),

              const SizedBox(height: 32),

              // ===== Big mic button + labels =====
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // TODO: реальна логіка старт/пауза слухання
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Listening toggle coming soon'),
                          ),
                        );
                      },
                      child: Container(
                        width: 180,
                        height: 180,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color(0xFFB18CFF),
                              Color(0xFF7C4DFF),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7C4DFF).withOpacity(0.35),
                              blurRadius: 28,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.mic,
                          size: 72,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Listening for Tone…',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E1E2D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tap to pause',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // ===== 4 cards =====
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.chat_bubble_outline,
                              iconBackground: const Color(0xFFE7DDFF),
                              title: 'AI Therapist',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const AiTherapistScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.sentiment_satisfied_outlined,
                              iconBackground: const Color(0xFFE5F7F0),
                              title: 'Calm Message',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const CalmMessageScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.mic_none,
                              iconBackground: const Color(0xFFFFF0DA),
                              title: 'Manual Record',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const ListeningScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _FeatureCard(
                              icon: Icons.favorite_border,
                              iconBackground: const Color(0xFFFFE5F0),
                              title: 'Positive Anchors',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const PositiveAnchorsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== Bottom nav =====
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          if (index == 0) {
            return;
          }
          if (index == 1) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const SessionsScreen(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('This section is coming soon'),
              ),
            );
          }
        },
        selectedItemColor: const Color(0xFF7C4DFF),
        unselectedItemColor: Colors.grey[500],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final String title;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: const Color(0xFF7C4DFF),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E1E2D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}